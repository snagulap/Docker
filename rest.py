from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta
import pandas as pd
from typing import Dict, List, Any
from pydantic import BaseModel
from hcpcore.data import expand_imp, ImpedanceCompensatorOpenShort
from hcpcore.algorithm import HcpMeanAlgorithm, HcpStatFeatureAlgorithm 
import hcpcore.toolbox as ht
from tb_device_mqtt import TBDeviceMqttClient, TBPublishInfo 
import requests
import os
from dotenv import load_dotenv
from typing import Union
from time import time, sleep
import logging
from logging.handlers import TimedRotatingFileHandler

from decouple import Config, Csv

log_handler = TimedRotatingFileHandler("logfile.log", when="midnight", backupCount=100)
logging.basicConfig(level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s", handlers = [log_handler], encoding = "UTF-8")


app = FastAPI()

#MQTT_BROKER = "hcp-demo-1.hcp-sense.com"
#DEVICE_TOKEN = "FvZnIaXVF06bI1cBILrL"

#BASE_URL = "http://hcp-demo-1.hcp-sense.com:8080"
#USERNAME = 'martin@hcp-sense.com'
#PASSWORD = 'J/?=)(7ßj098'

config = Config('F:\Hcp\hcp_py-core-fast-api-initial (1)\fast_api\src\hcpcore\.env')

# Access environment variables
#JWT_SECRET_KEY = config("JWT_SECRET_KEY")
#JWT_REFRESH_SECRET_KEY = config("JWT_REFRESH_SECRET_KEY")

ACCESS_TOKEN_EXPIRE_MINUTES = 30  # 30 minutes
REFRESH_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # 7 days
ALGORITHM = "HS256"

JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY', 'default_value')
JWT_REFRESH_SECRET_KEY = os.environ.get('JWT_REFRESH_SECRET_KEY', 'default_value')

#JWT_SECRET_KEY = os.environ['JWT_SECRET_KEY']   # should be kept secret
#JWT_REFRESH_SECRET_KEY = os.environ['JWT_REFRESH_SECRET_KEY']  # should be kept secret

# Create a CryptContext for password hashing
password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Define functions for password hashing and verification
def get_hashed_password(password: str) -> str:
    return password_context.hash(password)

# Simulated database (you should use a real database)
users_db = {
    "test@example.com": {
        "email": "test@example.com",
        "password": get_hashed_password("(123*§$%)")
    }
}



def verify_password(plain_password: str, hashed_password: str) -> bool:
    return password_context.verify(plain_password, hashed_password)

# Define functions to create access and refresh tokens
def create_access_token(subject: Union[str, Any], expires_delta: timedelta = None) -> str:
    if expires_delta is None:
        expires_delta = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    expire = datetime.utcnow() + expires_delta
    to_encode = {"exp": expire, "sub": str(subject)}
    encoded_jwt = jwt.encode(to_encode, JWT_SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def create_refresh_token(subject: Union[str, Any], expires_delta: timedelta = None) -> str:
    if expires_delta is None:
        expires_delta = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)
    expire = datetime.utcnow() + expires_delta
    to_encode = {"exp": expire, "sub": str(subject)}
    encoded_jwt = jwt.encode(to_encode, JWT_REFRESH_SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

ACCESS_TOKEN_EXPIRE_MINUTES = 30  # 30 minutes
REFRESH_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7  # 7 days
ALGORITHM = "HS256"

# Define models for Pydantic
class TokenSchema(BaseModel):
    access_token: str
    refresh_token: str

class User(BaseModel):
    email: str

class SystemUser(BaseModel):
    sub: str

# Define a route for user login
@app.post('/login', summary="Create access and refresh tokens for user", response_model=TokenSchema)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = users_db.get(form_data.username)
    if user is None or not verify_password(form_data.password, user["password"]):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect email or password"
        )

    access_token = create_access_token(user["email"])
    refresh_token = create_refresh_token(user["email"])
    return {
        "access_token": access_token,
        "refresh_token": refresh_token
    }

# Add the OAuth2PasswordBearer instance
reuseable_oauth = OAuth2PasswordBearer(
    tokenUrl="/login",
    scheme_name="JWT"
)

# Define a function to get the current user
async def get_current_user(token: str = Depends(reuseable_oauth)) -> SystemUser:
    try:
        payload = jwt.decode(
            token, JWT_SECRET_KEY, algorithms=[ALGORITHM]
        )
        token_data = SystemUser(**payload)

        if datetime.fromtimestamp(token_data.exp) < datetime.now():
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token expired",
                headers={"WWW-Authenticate": "Bearer"},
            )
    except jwt.JWTError:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = users_db.get(token_data.sub)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Could not find user",
        )

    return user

# Define a route to get the current user based on the token
@app.get('/me', summary='Get details of the currently logged-in user', response_model=User)
async def get_me(user: User = Depends(get_current_user)):
    return user

class HcpDataFrame(BaseModel):
    time_sec: List[float]
    speed: List[float]
    tem: List[float]
    imp_im: List[float]
    imp_re: List[float]



@app.post("/post_impedance/")
async def post_impedance(data: HcpDataFrame, current_user: dict = Depends(reuseable_oauth)):


    # construct DataFrame
    df = pd.DataFrame({
        "time_sec": data.time_sec,
        "speed": data.speed,
        "tem": data.tem,
        "imp_im": data.imp_im,
        "imp_re": data.imp_re,
    })

    print(df)

    #  replace NaNs in tem with -999
    df['tem'] = df['tem'].fillna(-999)

    return df.to_dict(orient='list')



if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

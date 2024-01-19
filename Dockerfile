#Dockerfile 

FROM ubuntu:22.04

ENV PATH="/home/srini/Fastapi_app/conda/bin:${PATH}"
ARG PATH="/home/srini/Fastapi_app/conda/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get -y install openssh-server && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/srini/Fastapi_app/conda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

# Set the environment variable
ENV PATH="/home/srini/Fastapi_app/conda/bin:${PATH}"

# Install Python 3.10 using conda
RUN /home/srini/Fastapi_app/conda/bin/conda install -y python=3.10 && \
    /home/srini/Fastapi_app/conda/bin/conda clean -afy

# Create a virtual environment and upgrade pip
RUN /home/srini/Fastapi_app/conda/bin/python -m venv /home/srini/Fastapi_app/myenv && \
    /home/srini/Fastapi_app/myenv/bin/pip install --upgrade pip

# Activate the virtual environment
#RUN echo "conda /home/srini/Fastapi_app/myenv/bin/activate" >> /root/.bashrc

# Create the directory for the SSH key
RUN mkdir -p /home/srini/Fastapi_app/myenv/ssh-key

#mkdir -p /home/srini/hcp_py-core/logfile.log

# Change to the directory for the SSH key
COPY ./kez /home/srini/Fastapi_app/myenv/ssh-key
COPY ./kez.pub /home/srini/Fastapi_app/myenv/ssh-key

RUN mkdir -p /root/.ssh
COPY ./.ssh /root/.ssh 
#RUN chmod 600 home/srini/Fastapi_app/myenv/ssh-key/kez

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

#RUN ssh-keyscan github.com >> ~/.ssh/know
RUN conda install wheel



# Clone the repository and install dependencies
RUN git -c core.sshCommand="ssh -i /home/srini/Fastapi_app/myenv/ssh-key/kez" clone --branch fast-api-export-endpoint git@github.com:HCP-Sense/hcp_py-core.git \
    && cd hcp_py-core \
    && python setup.py bdist_wheel --universal \
    && python -m pip install . \
    && pip install -r requirements.txt \
    && pip install tb-mqtt-client \
    && pip install pymmh3 \
    && pip install azure-storage-blob \
    && pip install azure-identity

#WORKDIR /home/srini/Fastapi_app/myenv/hcp_py-core
EXPOSE 80

#RUN mkdir -p /hcp_py-core
RUN touch /hcp_py-core/logfile.log

RUN chmod +rw /hcp_py-core/logfile.log


RUN rm -rf /home/srini/Fastapi_app/myenv/ssh-key
RUN rm -rf /root/.ssh
#CMD ["/bin/bash"]
#CMD ["uvocorn","restapi:app","--host","0.0.0.0","--port","80"]
#CMD ["uvicorn", "hcp_py-core.src.hcpcore.restapi:app", "--host", "0.0.0.0", "--port", "8000"]


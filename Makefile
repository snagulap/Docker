all:
	sudo rm -Rf ~/data
	mkdir -p ~/data/wordpress
	mkdir -p ~/data/mariadb
	sudo docker compose -f ./src/docker-compose.yml up

build:
	sudo rm -Rf ~/data
	mkdir -p ~/data/wordpress
	mkdir -p ~/data/mariadb
	sudo docker compose -f ./src/docker-compose.yml up --build

down:
	sudo docker compose -f ./src/docker-compose.yml down
	sudo docker volume rm mariadb
	sudo docker volume rm wordpress

fclean: down
	sudo rm -Rf ~/data
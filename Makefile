all:
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/mariadb
	@sudo docker-compose -f ./src/docker-compose.yml up

build:
	@sudo rm -Rf ~/data
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/mariadb
	@sudo docker-compose -f ./src/docker-compose.yml up --build

down:
	@sudo docker-compose -f ./src/docker-compose.yml down
	@sudo docker volume rm mariadb
	@sudo docker volume rm wordpress

clean:
	@sudo docker stop $$(sudo docker ps -qa) || true
	@sudo docker rm $$(sudo docker ps -qa) || true
	@sudo docker rmi -f $$(sudo docker images -qa) || true
	@sudo docker volume rm $$(sudo docker volume ls -q) || true

fclean: down clean
	@sudo rm -Rf ~/data

.PHONY: all build down clean fclean


# all:
# 	mkdir -p ~/data/wordpress
# 	mkdir -p ~/data/mariadb
# 	sudo docker-compose -f ./src/docker-compose.yml up

# build:
# 	sudo rm -Rf ~/data
# 	mkdir -p ~/data/wordpress
# 	mkdir -p ~/data/mariadb
# 	sudo docker-compose -f ./src/docker-compose.yml up --build

# down:
# 	sudo docker-compose -f ./src/docker-compose.yml down
# 	sudo docker volume rm mariadb
# 	sudo docker volume rm wordpress

# clean:
# 	sudo docker stop $$(sudo docker ps -qa) || true
# 	sudo docker rm $$(sudo docker ps -qa) || true
# 	sudo docker rmi -f $$(sudo docker images -qa) || true
# 	sudo docker volume rm $$(sudo docker volume ls -q) || true

# fclean: down clean
# 	sudo rm -Rf ~/data

# .PHONY: all build down clean fclean


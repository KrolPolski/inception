# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rboudwin <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/25 15:15:57 by rboudwin          #+#    #+#              #
#    Updated: 2025/04/25 15:16:00 by rboudwin         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
ENV_FILE := srcs/.env
DATA_DIR := ./data
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb

NAME = inception

all: create_dirs make_dir_up

build: create_dirs make_dir_up_build

down:
	@echo "Stopping inception containers:"
	docker compose -f ${DOCKER_COMPOSE_FILE} --env-file ${ENV_FILE} down

up:
	@echo "Starting inception containers:"
	docker compose -f ${DOCKER_COMPOSE_FILE} --env-file ${ENV_FILE} up -d
re: down clean create_dirs make_dir_up_build

clean: down
	@echo "Cleaning inception containers:"
	docker system prune -a
	sudo rm -rf ${WORDPRESS_DATA_DIR}/*
	sudo rm -rf ${MARIADB_DATA_DIR}/*

fclean: down
	@echo "Complete purge of all configs:"
	docker system prune --all --force --volumes
	docker network prune --force
	docker volume prune --force
	sudo rm -rf ${WORDPRESS_DATA_DIR}/*
	sudo rm -rf ${MARIADB_DATA_DIR}/*
	sudo rm -rf ${DATA_DIR}

logs:
	docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

create_dirs:
	@echo "Creating data directories to mount docker volumes to:"
	mkdir -p ${WORDPRESS_DATA_DIR}
	mkdir -p ${MARIADB_DATA_DIR}

make_dir_up: 
	@echo "Launching inception containers:"
	docker compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d

make_dir_up_build:
	@echo "Building inception containers:"
	docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build


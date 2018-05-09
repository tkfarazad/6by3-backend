RAILS_ENV ?= development
PROJECT_NAME := lyftaapi
RUN := run --rm
DOCKER_COMPOSE := docker-compose --project-name $(PROJECT_NAME)
DOCKER_COMPOSE_RUN := $(DOCKER_COMPOSE) $(RUN)
WEB_CONCURRENCY := 0

default: bin-rspec

bin-rspec:
	bin/rspec

provision: bundle db-migrate

api:
	${DOCKER_COMPOSE_RUN} --service-ports -e "WEB_CONCURRENCY=${WEB_CONCURRENCY}" api

db-migrate:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" app bundle exec rake db:migrate

bash:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" app bash

compose:
	${DOCKER_COMPOSE} ${CMD}

down:
	${DOCKER_COMPOSE} down

down-v:
	${DOCKER_COMPOSE} down -v

bundle:
	${DOCKER_COMPOSE_RUN} app bundle ${CMD}

test:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=test" app bundle exec rspec ${T}

psql:
	${DOCKER_COMPOSE_RUN} app psql postgresql://postgres@db/matchmaking_${RAILS_ENV}

build:
	${DOCKER_COMPOSE} build

rebuild:
	${DOCKER_COMPOSE} build --force-rm

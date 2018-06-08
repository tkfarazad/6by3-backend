# 6by3 API

[![CircleCI](https://circleci.com/gh/Jetfuelcoordinator/6by3-backend/tree/master.svg?style=svg&circle-token=df6512fdc20505fcf2ed59ab81be9255554cc640)](https://circleci.com/gh/Jetfuelcoordinator/6by3-backend/tree/master)

## Requirements

* [Docker & Docker compose](https://docs.docker.com/compose/install/)
* [Docker Interaction Process](https://github.com/bibendi/dip)

## Install

### First install

1. configure environment variables
```bash
cp .env.development .env.development.local
# set your environments (you can use any text editor) vim, nano whatever
vi .env.development.local
```
2. setup project

```bash
make provision
```

### After you pulling new code

```bash
make provision
```

### Install test environment (only if you need to run tests)
```
RAILS_ENV=test make provision
```

## Usage

all actual tasks you can see in Makefile

### Run API

```
make api
```
after that api will be available on http://localhost:3001/

### Go to app container

```
make bash
```

### Down containers

```
make down
```

down and remove all volumes:
```
make down-v
```

## To use nfsmount

1. set `export USE_NFSMOUNT=true` in your shell config
2. setup and run `setup_native_nfs_docker_osx.sh` script from https://gist.github.com/seanhandley/7dad300420e5f8f02e7243b7651c6657

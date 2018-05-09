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

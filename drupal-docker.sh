#!/usr/bin/env bash
set -e

DRUPAL_DIR="$( pwd )"
DOCKER_DIR="$( cd "$( dirname "$( readlink ${BASH_SOURCE[0]})" )" && pwd )"

PROJECT_NAME=${PWD##*/}

if [ -z "$DOCKER_DIR" ]; then
    echo "Couldn't find drupal-docker directory."
    exit 1
fi

#rm -rf $DOCKER_DIR/data
#mkdir $DOCKER_DIR/data
#cp -R ~/.ssh $DOCKER_DIR/data
#cp -R $DRUPAL_DIR $DOCKER_DIR/data/drupal
## todo: locate dump directory over arguments
#mkdir $DOCKER_DIR/data/dump

if [ "$1" == "dev" ]; then
    COMPOSE_ARGS="-f $DOCKER_DIR/docker-compose.dev.yml -p $PROJECT_NAME"
    if [ "$2" != "cmd" ]; then
        docker-compose $COMPOSE_ARGS rm -sfv
        echo "Stopped all containers"
    else
        shift
        shift
        echo "Run $@ in Drupal container"
        docker-compose $COMPOSE_ARGS run -u www-data --rm web $@
    fi

    if [ "$2" == "start" ]; then
        docker-compose $COMPOSE_ARGS build --pull
        docker-compose $COMPOSE_ARGS up -d
        echo "Drupal is running now under http://localhost:8090/"
    fi
fi

if [ "$1" == "test" ]; then
    shift
    ID=( $(openssl rand 100000 | md5) );

    set +e
    COMPOSE_ARGS="-f $DOCKER_DIR/docker-compose.test.yml -p ${PROJECT_NAME}${ID}"
    docker-compose $COMPOSE_ARGS rm -sfv
    docker-compose $COMPOSE_ARGS build --pull
    docker-compose $COMPOSE_ARGS run --rm web ./vendor/bin/phpunit --log-junit /tmp/tests/phpunit-junit-log.xml --exclude-group ignore $@
    #docker-compose $COMPOSE_ARGS down --rmi local -v
    docker-compose $COMPOSE_ARGS rm -sfv
    set -e
    cp -r $DOCKER_DIR/data/test_output $DRUPAL_DIR
fi

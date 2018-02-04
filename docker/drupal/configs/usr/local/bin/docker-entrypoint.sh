#!/usr/bin/env bash

PATH=$PATH:/var/www/html/vendor/bin/

if [ ! -z "$1" ]; then
    # a cmd is given so run (e.g. composer/drush)
    CMD=$1
    shift
    echo "Running $CMD $@"
    $CMD $@
else
    # make files accessible for www-data
    chown www-data:wwwadmin /var/www/html/web/sites/default/files

    # wait till db is up
    while ! mysql -hdb -udocker -pdocker  -e ";" ; do
        echo "Waiting DB container db not up yet"
        sleep 5
    done

    # start apache
    apache2-foreground
fi

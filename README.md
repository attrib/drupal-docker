# Docker wrapper for Drupal

This is a wrapper to run Drupal projects inside docker.

This example uses apache, php7, mariadb, redis, solr.

Solr config should be located under solr inside Drupal directory. For example config (settings.php, ect) see attrib/drupal-test

If you used drupal-composer/drupal-project remove pre and post-install-cmd in composer.json.

### Mac & Linux

`sudo ln -s `pwd`/drupal-docker.sh /usr/local/bin/drupal-docker`

#### Local development

Start all services with `drupal-docker dev start`

Use drush `drupal-docker dev cmd drush cr`

Stop all services with `drupal-docker dev stop`

#### Run tests

Run tests: `drupal-docker test`

Add to test for more output `--verbose --debug`

Testing core: `drupal-docker test web/core -c web/core --group breadcrumb`

### Windows

not yet implemented

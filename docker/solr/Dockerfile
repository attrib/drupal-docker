FROM solr:7-alpine

MAINTAINER Karl Fritsche <github@attrib.org>

USER solr

COPY ./data/drupal/solr /solr-conf/conf

ENTRYPOINT ["docker-entrypoint.sh", "solr-precreate", "docker", "/solr-conf"]

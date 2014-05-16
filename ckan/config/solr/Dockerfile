FROM makuk66/docker-solr
MAINTAINER Open Knowledge Foundation

ENV SOLRHOME /opt/solr/example/solr

RUN cp -R $SOLRHOME/collection1/ $SOLRHOME/ckan_default/
RUN echo "name=ckan_default" > $SOLRHOME/ckan_default/core.properties
ADD schema.xml $SOLRHOME/ckan_default/conf/schema.xml

# We inherit the default CMD from makuk66/docker-solr

FROM alpine:3.12
#
# VARS
ENV LS_VER=7.10.1
# Include dist
ADD dist/ /root/dist/
#
# Setup env and apt
RUN sed -i 's/dl-cdn/dl-2/g' /etc/apk/repositories && \
    apk -U --no-cache add \
             aria2 \
             bash \
             bzip2 \
	     curl \
             libc6-compat \
             libzmq \
             nss \
             openjdk11-jre && \
#
# Get and install packages
    cd /root/dist/ && \
    mkdir -p /usr/share/logstash/ && \
    aria2c -s 16 -x 16 https://artifacts.elastic.co/downloads/logstash/logstash-$LS_VER-linux-x86_64.tar.gz && \
    tar xvfz logstash-$LS_VER-linux-x86_64.tar.gz --strip-components=1 -C /usr/share/logstash/ && \
    rm -rf /usr/share/logstash/jdk && \
#
# Add and move files
    cd /root/dist/ && \
    mkdir -p /etc/logstash/conf.d && \
    cp logstash.conf /etc/logstash/conf.d/ && \
    cp es_template.json /etc/logstash/ && \
#
# Setup user, groups and configs
    chown -R 1000:1000 /usr/share/logstash && \
#
# Clean up
    rm -rf /root/* && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
#
# Healthcheck
HEALTHCHECK --retries=10 CMD curl -s --cacert /usr/share/elasticsearch/config/certs/ca/ca.crt -s http://127.0.0.1:9600 >/dev/null; if [ $? == 0 ]; then echo 0; else echo 1; fi
#
# Start logstash
#CMD /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf --config.reload.automatic --java-execution --log.level debug
CMD /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf --config.reload.automatic --java-execution

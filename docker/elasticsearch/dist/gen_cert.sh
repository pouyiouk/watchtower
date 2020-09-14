#!/bin/bash
if [[ ! -f /data/elastic/certs/bundle.zip ]]; 
  then
    echo "First start, generating certs ..."
    /usr/share/elasticsearch/bin/elasticsearch-certutil cert --silent --pem --in /usr/share/elasticsearch/config/instances.yml -out /usr/share/elasticsearch/config/certs/bundle.zip;
    unzip /usr/share/elasticsearch/config/certs/bundle.zip -d /usr/share/elasticsearch/config/certs;
    #chown -R 1000:0 /data/elastic/certs
    /usr/share/bin/elasticsearch -d -Des.insecure.allow.root=true
    while [[ 2 -gt 1 ]]
      do
        curl --cacert /usr/share/elasticsearch/config/certs/ca/ca.crt -s https://127.0.0.1:9200
	if [[ $? == 0 ]];
	  then
            break
	fi
	sleep 1
    done
    echo "Elasticsearch is up, now setting up account passwords ..."
    /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto --batch --url https://elasticsearch:9200 > /data/elastic/conf/passwords
    exit
fi;

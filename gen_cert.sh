#!/bin/bash

### USAGE: 
# $1 PSM IP
# $2 Password for Trustore


openssl genrsa 2048 > files/host.key

openssl req -new -x509 -extensions SAN -nodes -sha1 -days 1001 \
-key files/host.key -out files/host.crt -reqexts SAN \
-config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=IP:"$1)) \
-subj '/CN=PacketLogic Subscriber Manager'

keytool -import -noprompt -storepass $2 -alias $1 -file files/host.crt -keystore files/client.truststore

keytool -list -v -alias $1  -keystore files/client.truststore -storepass $2

cp files/client.truststore ../nifi/client.truststore

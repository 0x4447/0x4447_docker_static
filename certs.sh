#!/bin/bash
set -e

DOMAIN="${1:-localhost}"

echo "$DOMAIN"

CA_KEY=/etc/ssl/ca.key
CA_CRT=/etc/ssl/ca.pem

SERVER_KEY=/etc/ssl/server.key
SERVER_REQ=/etc/ssl/server.csr
SERVER_CRT=/etc/ssl/server.pem

SERVER_SUB="/C=US/ST=Texas/L=Dallas/O=Aztek/CN=$DOMAIN"

SAN_CONFIG=/etc/ssl/san.cnf

cat > "$SAN_CONFIG" << SAN_CONFIG
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext

[ req_distinguished_name ]
countryName         = Country Name (2 letter code)
stateOrProvinceName = State or Province Name (full name)
localityName        = Locality Name (eg, city)
organizationName    = Organization Name (eg, company)
commonName          = Common Name (eg, YOUR name)

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1   = $DOMAIN
DNS.2   = $(hostname -i)
SAN_CONFIG

if ! test -f "$CA_CRT"; then
    openssl genrsa 2048 > "$CA_KEY"

    openssl req \
        -new \
        -x509 \
        -nodes \
        -days 3650 \
        -subj "$SERVER_SUB" \
        -config "$SAN_CONFIG" \
        -key "$CA_KEY" \
        -out "$CA_CRT"

    chown "nginx:www-data" "$CA_CRT"
fi

if ! test -f "$SERVER_CRT"; then
    openssl req \
        -newkey rsa:2048 \
        -days 3650 \
        -nodes \
        -subj "$SERVER_SUB" \
        -config "$SAN_CONFIG" \
        -keyout "$SERVER_KEY" \
        -reqexts req_ext \
        -out "$SERVER_REQ"

    openssl rsa \
        -in "$SERVER_KEY" \
        -out "$SERVER_KEY"

    openssl x509 \
        -req \
        -in "$SERVER_REQ" \
        -days 3650 \
        -CA "$CA_CRT" \
        -CAkey "$CA_KEY" \
        -extfile "$SAN_CONFIG" \
        -extensions req_ext \
        -set_serial 01 \
        -out "$SERVER_CRT"
fi

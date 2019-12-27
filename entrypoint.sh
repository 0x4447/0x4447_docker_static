#!/bin/bash
set -ex

main(){
    env_init
    generate_certs
    setup_nginx
}

env_init(){
    DOMAIN="${DOMAIN:-"localhost"}"
}

generate_certs(){
    bash certs.sh "$DOMAIN"
}

setup_nginx(){
    sed -i "s/DOMAIN/$DOMAIN/g" "/etc/nginx/sites-enabled/$DOMAIN/server.conf"
    nginx -t

    service nginx start && tail -f /var/stdout
}

main

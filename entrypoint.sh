#!/bin/sh
set -e

main(){
    env_init
    generate_certs
}

env_init(){
    if test -n "$DOMAIN"; then
        DOMAIN=localhost
        export DOMAIN
    fi
}

generate_certs(){
    bash certs.sh "$DOMAIN"
}

main

#!/bin/bash
set -e

main(){
    generate_certs
    setup_nginx
}

generate_certs(){
    bash certs.sh "$DOMAIN" 2> /dev/null
}

setup_nginx(){
    sed -i "s/DOMAIN/$DOMAIN/g" "/etc/nginx/sites-enabled/$DOMAIN/server.conf"
    nginx -t 2> /dev/null

    cat << EOF
Starting Nginx for https://$DOMAIN
  * Don't forget to poison your hosts file to resolve DNS.
EOF
    service nginx start && {
        echo "  * Now serving requests."
        tail -f /dev/stdout
    }
}

main

FROM nginx:1.17.6

ARG DOMAIN=localhost
ENV DOMAIN=${DOMAIN}

# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update && \
        apt-get install -y \
            curl \
            openssl

WORKDIR /opt/nginx
COPY ["entrypoint.sh",  "."]
COPY ["certs.sh",       "."]
COPY ["nginx.conf",     "."]

COPY ["server.conf",    "/etc/nginx/sites-enabled/${DOMAIN}/server.conf"]

EXPOSE 443

ENTRYPOINT ["/opt/nginx/entrypoint.sh", "${DOMAIN}"]

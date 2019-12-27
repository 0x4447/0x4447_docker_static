FROM nginx:1.17.6

ARG DOMAIN
ENV DOMAIN=${DOMAIN}

# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update && \
        apt-get install -y openssl

COPY ["entrypoint.sh",  "/opt/nginx/"]
COPY ["certs.sh",       "/opt/nginx/"]
COPY ["nginx.conf",     "/etc/nginx/"]
COPY ["server.conf",    "/etc/nginx/sites-enabled/${DOMAIN}/server.conf"]

WORKDIR /opt/nginx

ENTRYPOINT ["/opt/nginx/entrypoint.sh", "${DOMAIN}"]

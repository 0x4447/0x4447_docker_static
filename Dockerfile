FROM nginx:1.17.6

ARG DOMAIN
ENV DOMAIN=${DOMAIN}

WORKDIR /opt/nginx

# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update && \
        apt-get install -y openssl

COPY ["entrypoint.sh", "/opt/nginx/"]
COPY ["certs.sh", "/opt/nginx/"]

ENTRYPOINT ["/opt/nginx/entrypoint.sh", "${DOMAIN}"]

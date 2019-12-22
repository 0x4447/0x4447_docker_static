FROM nginx:1.17.6

ARG DOMAIN

WORKDIR /opt/nginx

COPY ["entrypoint.sh", "/opt/nginx/"]

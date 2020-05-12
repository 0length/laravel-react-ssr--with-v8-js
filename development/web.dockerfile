FROM nginx:1.13.9-alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY development/vhost.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www
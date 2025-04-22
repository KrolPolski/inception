FROM alpine:3.20.6
RUN apk update && apk add nginx openssl bash
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/CN=${DOMAIN_NAME:-localhost}"
#COPY tools/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/nginx.conf /etc/nginx/nginx.conf
EXPOSE 443
#CMD ["tail", "-f", "/dev/null"]
#CMD ["wait 360"]
#CMD ["nginx"] 
#CMD ["bash"]
#CMD ["nginx", "-g", "'daemon off'", ";"]
CMD ["nginx", "-g", "daemon off;"]

FROM ubuntu:18.04

RUN apt clean && apt update && apt upgrade -y && \
	apt install nginx spawn-fcgi fcgiwrap wget curl bash bc nano vim ruby jq -y && \
	apt clean

# Redirect logs to stderr and stdout

RUN mkdir /app && \
	sed -i -e 's@access_log /var/log/nginx/access.log;@access_log /proc/self/fd/1;@g' \
	-e 's@error_log /var/log/nginx/error.log;@error_log /proc/self/fd/2;@g' /etc/nginx/nginx.conf

ADD ./app/conf /app/conf
ADD ./app/bin /app/bin
ADD ./app/create-links.sh /app/create-links.sh
ADD ./app/update-ffmpeg.sh /app/update-ffmpeg.sh

RUN /app/update-ffmpeg.sh && /app/create-links.sh

WORKDIR /var/www

CMD /etc/init.d/fcgiwrap start && nginx -g 'daemon off;'

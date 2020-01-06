#!/usr/bin/env bash

FFMPEG_STATIC_DIR=$(cd /app/ffmpeg-*static; pwd)

if [ ! -z "${FFMPEG_STATIC_DIR}" ]; then
	ln -vs "${FFMPEG_STATIC_DIR}" /app/ffmpeg
	ln -vs /app/ffmpeg/{ffmpeg,ffprobe} /usr/local/bin/
else
	echo "Missing FFMPEG static binaries directory" >&2
fi

FASTCGI_SCRIPTS_LANG="sh"
case "${FASTCGI_SCRIPTS_LANG}" in
    sh)
	cd /app/bin/ && ln -vs hls-m3u8.sh hls-m3u8 && ln -vs hls-ts.sh hls-ts
    ;;  
    *)
      	cd /app/bin/ && ln -vs hls-m3u8.rb hls-m3u8 && ln -vs hls-ts.rb hls-ts
    ;;
esac

ln -vs /app/bin/{hls-m3u8,hls-ts} /var/www/

if [ -f "/etc/nginx/sites-enabled/default" ];then
  rm -v "/etc/nginx/sites-enabled/default"
fi

ln -vs /app/conf/default-site /etc/nginx/sites-enabled/default-site

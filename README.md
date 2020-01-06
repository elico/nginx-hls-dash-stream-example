
## Building the docker image
`docker build -t nginx-streamer .`

## Running
```bash
docker run -it \
	-p 8080:80 \
	--mount type=volume,source=nginx-stream-app,target=/app,volume-driver=local \
	--mount type=bind,source=/mnt/data,target=/var/www/html/data \
	--mount type=tmpfs,destination=/tmp,tmpfs-mode=1770,tmpfs-size=1g \
	nginx-streamer
```
## Refrences links
- <https://www.youtube.com/watch?v=t8ebB9Pxb2s>
- <https://github.com/shimberger/gohls>
- <https://gist.github.com/spiermar/b389b96642fb973d0cc9766ee7b559ac>
- <https://medium.com/@lojorider/docker-with-cgi-perl-a4558ab6a329>
- <https://github.com/shimberger/gohls/blob/master/internal/hls/playlist.go>
- <https://johnvansickle.com/ffmpeg/>
- <https://www.server-world.info/en/note?os=Ubuntu_18.04&p=nginx&f=5>
- <https://github.com/docker-library/httpd/blob/b13054c7de5c74bbaa6d595dbe38969e6d4f860c/2.2/Dockerfile#L72-L75>
- <https://www.techevents.online/nginx-conf-2016/streaming-hls-dash-nginx/>
- <https://talks.golang.org/2013/oscon-dl.slide#45>

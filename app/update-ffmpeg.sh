#!/usr/bin/env bash

FFMPEG_RELEASE_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"

#if [[ -n "${CUSTOM_FFMPEG_RELEASE_URL}" ]]; then
if [[ -v CUSTOM_FFMPEG_RELEASE_URL ]]; then
	FFMPEG_RELEASE_URL="${CUSTOM_FFMPEG_RELEASE_URL}"
fi

function downloadFfmpeg(){
	wget ${FFMPEG_RELEASE_URL} -O /tmp/ffmpeg-release-amd64-static.tar.xz
}

function cleanup(){
	stat /app/ffmpeg && rm -rfv /app/ffmpeg
	FFMPEG_STATIC_DIR=$(ls /app/ffmpeg*-static |wc -l)
	if [ "${FFMPEG_STATIC_DIR}" -gt "0" ]; then
		rm -rfv /app/ffmpeg*-static
	fi
}

FORCE=0

if [ -f "/app/force-ffmpeg-update" ];then
	FORCE=1
fi

FFMPEG_DIR_EXISTS=0
FFMPEG_BIN_EXISTS=0
FFPROBE_BIN_EXISTS=0

stat /app/ffmpeg
RES=$?
if [ "$RES" -eq "0" ];then
	FFMPEG_DIR_EXISTS=1
fi

stat /app/ffmpeg/ffmpeg
RES=$?
if [ "$RES" -eq "0" ];then
	FFMPEG_BIN_EXISTS=1
fi

stat /app/ffmpeg/ffprobe
RES=$?
if [ "$RES" -eq "0" ];then
        FFPROBE_BIN_EXISTS=1
fi

if [ "${FFMPEG_DIR_EXISTS}" -eq "0" ]; then
	FORCE=1
fi

if [ "${FORCE}" -eq "1" ];then
	downloadFfmpeg
	stat /tmp/ffmpeg-release-amd64-static.tar.xz && \
	cleanup && \
	tar xf /tmp/ffmpeg-release-amd64-static.tar.xz -C /app/

	FFMPEG_STATIC_DIR=$(cd /app/ffmpeg-*static; pwd)

	ln -vs "${FFMPEG_STATIC_DIR}" /app/ffmpeg

	rm -v "/app/force-ffmpeg-update"
	rm -v "/tmp/ffmpeg-release-amd64-static.tar.xz"
fi

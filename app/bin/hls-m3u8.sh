#!/usr/bin/env bash

#hls-m3u8

f=$( echo "${DOCUMENT_ROOT}${REQUEST_URI}" | sed 's/\.m3u8//' )
if [ ! -f "${f}" ]; then
    echo -e "Status: 404 Not Found\n"
    exit
fi

filename=$( echo "${f}" | sed 's/.\+\///' )
keys=$( ffprobe -select_streams v -skip_frame nokey -show_frames -v quiet "${f}" | grep '^pkt_pts_time' | sed 's/pkt_pts_time=//' )

echo "Content-Type: application/x-mpegURL"
echo ""

echo "#EXTM3U"
echo "#EXT-X-VERSION:3"
echo "#EXT-X-SEQUENCE:0"
echo "#EXT-X-ALLOW-CACHE:YES"
echo "#EXT-X-TARGETDURATION:10"

prev="0"

for i in ${keys}; do
    duration=$( echo "${i}-${prev}"| bc )
    echo "#EXTINF:${duration},"
    echo "${filename}.$(echo "${prev}*1000"| bc | grep -o '^[0-9]\+').ts"
    prev="${i}"
done

echo "#EXT-X-ENDLIST"

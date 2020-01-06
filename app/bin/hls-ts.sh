#!/usr/bin/env bash

#hls-ts

f=$(echo "${DOCUMENT_ROOT}${REQUEST_URI}" | sed 's/\.[0-9]\+\.ts//')

x=$(echo "${REQUEST_URI}" | sed 's/\.ts//'| grep -o '[0-9]\+$')

if [ ! -f  "${f}" ]; then
    echo -e "Status 404 Not Found\n"
    exit
fi

filename=$(echo "${f}" | sed 's/.\+\///' )

tmp=$( mktemp -d  )

xx=$( echo "${x}" | sed -e 's/^/00000/' -e 's/\([0-9]\{3\}\)$/.\1/' -e 's/^\./0./' )

ss=$( echo "${xx}+0.3" | bc | sed 's/^/0/' )

tt=$( echo "${xx}+10.000" | bc )

mp4s="${tmp}/${filename}.${x}.mp4"

mp2ts="${tmp}/${filename}.${x}.ts"

ffmpeg -ss "${ss}" -itsoffset "${ss}" -i "${f}" -t "${tt}" -codec copy -loglevel quiet -y "${mp4s}"

ffmpeg -itsoffset "${ss}" -i "${mp4s}" -codec copy -vbsf h264_mp4toannexb -flags -global_header -segment_format mpegts -loglevel quiet "${mp2ts}"

echo "Content-Type: video/MP2T"
echo ""

cat "${mp2ts}"
rm -rf "${tmp}"

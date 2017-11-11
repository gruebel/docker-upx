#!/bin/sh
GREEN='\033[0;32m'
NC='\033[0m'

# run test with fd binaries
wget -q -O fd.tar.gz https://github.com/sharkdp/fd/releases/download/v5.0.0/fd-v5.0.0-x86_64-unknown-linux-gnu.tar.gz 

tar xpf fd.tar.gz --strip-components=1

printf "${GREEN}\n[Test] check compression functionality + duration\n${NC}" 
time -p docker run --rm -w ${PWD} -v ${PWD}:${PWD} ${DOCKER_IMAGE_VERSION_NAME} --best --lzma -o fd_upx fd

printf "${GREEN}\n[Test] check execution of Rust binaries + duration\n${NC}"
time -p ./fd 'Dockerfile.*' /
time -p ./fd_upx 'Dockerfile.*' /

printf "${GREEN}\n[Test] check file size\n${NC}"
ls -lah fd fd_upx

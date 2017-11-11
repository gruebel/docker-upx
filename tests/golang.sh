#!/bin/sh
GREEN='\033[0;32m'
NC='\033[0m'

# run test with hugo binaries
wget -q -O hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.30.2/hugo_0.30.2_Linux-64bit.tar.gz

tar xpf hugo.tar.gz

printf "${GREEN}\n[Test] check compression functionality + duration\n${NC}" 
time -p docker run --rm -w ${PWD} -v ${PWD}:${PWD} ${DOCKER_IMAGE_VERSION_NAME} --best --lzma -o hugo_upx hugo

printf "${GREEN}\n[Test] check execution of Golang binaries + duration\n${NC}"
time -p ./hugo version
time -p ./hugo_upx version

printf "${GREEN}\n[Test] check file size\n${NC}"
ls -lah hugo hugo_upx

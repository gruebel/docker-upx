# UPX

[![Build Status](https://travis-ci.org/gruebel/docker-upx.svg?branch=master)](https://travis-ci.org/gruebel/docker-upx)
[![Docker Automated build](https://img.shields.io/docker/automated/gruebel/upx.svg)](https://hub.docker.com/r/gruebel/upx/builds/)

## Overview
A small image for usage in multi-stage Docker builds to compress binary files like Go or Rust.
Based on the official busybox image and build via multi-stage build himself to make the image as small as possible **~1.7MB**
For more information on the great tool UPX check out their [GitHub project](https://github.com/upx/upx)!

## Usage
### CMD
To compress any file run following command

```bash
$ docker run --rm -w $PWD -v $PWD:$PWD gruebel/upx:latest --best --lzma -o [compressed file name] [file name]
```

### Docker multi-stage build
For this example I used the official example of the Docker documentation for [multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/#name-your-build-stages)

```docker
FROM golang:1.7.3 as builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Before copying the Go binary directly to the final image,
# add them to the intermdediate upx image
FROM gruebel/upx:latest as upx
COPY --from=builder /go/src/github.com/alexellis/href-counter/app /app.org

# Compress the binary and copy it to final image
RUN upx --best --lzma -o /app /app.org

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=upx /app .
CMD ["./app"] 
```


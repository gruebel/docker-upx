FROM alpine:3.6 as builder

# devel branch
ENV UPX_COMMIT_HASH=0430e79 \
    LDFLAGS=-static

# download source and compile
RUN apk add --no-cache \
    build-base \
    git \
    ucl-dev \
    zlib-dev \
 && git clone -b devel --recursive https://github.com/upx/upx.git /upx \
 && cd /upx \
 && git reset --hard ${UPX_COMMIT_HASH} \
 && cd /upx/src \
 && sed -i 's/ -O2/ /' Makefile \
 && make -j10 upx.out CHECK_WHITESPACE=

# compress himself; absolutley barbaric ;)
RUN /upx/src/upx.out \
    --lzma \
    -o /usr/bin/upx \
    /upx/src/upx.out

FROM busybox:1.27.2

COPY --from=builder /usr/bin/upx /usr/bin/upx

ENTRYPOINT ["/usr/bin/upx"]

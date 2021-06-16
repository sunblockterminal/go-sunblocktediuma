# Build Gsbt in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-sunblocktediuma
RUN cd /go-sunblocktediuma && make gsbt

# Pull Gsbt into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-sunblocktediuma/build/bin/gsbt /usr/local/bin/

EXPOSE 7664 7665 33560 33560/udp
ENTRYPOINT ["gsbt"]

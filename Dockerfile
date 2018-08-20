FROM golang:1.10.3 AS builder

ARG SRC_ROOT=/usr/local/go/src/github.com/cbroglie/cloud-echo

COPY . $SRC_ROOT/
WORKDIR $SRC_ROOT

RUN make && cp cloud-echo /cloud-echo

FROM alpine:3.8

RUN apk --no-cache add curl

USER nobody

COPY --from=builder /cloud-echo /cloud-echo

ENTRYPOINT /cloud-echo

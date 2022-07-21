# golang:1.18.4
FROM golang@sha256:9349ed889adb906efa5ebc06485fe1b6a12fb265a01c9266a137bb1352565560 as builder

WORKDIR /workspace
COPY . ./

RUN make build

# Use distroless as minimal base image to package the cloud-echo binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/bin/cloud-echo /cloud-echo
USER nonroot:nonroot

ENTRYPOINT ["/cloud-echo"]

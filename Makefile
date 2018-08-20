.PHONY: all
all: build

.PHONY: build
build:
	CGO_ENABLED=0 go build -a -installsuffix cgo -o cloud-echo .

.PHONY: image
image:
	docker build -t us.gcr.io/cf-sec-eng/cloud-echo:$(shell git describe --tags --dirty=-dev) .

.PHONY: push
push:
	docker push us.gcr.io/cf-sec-eng/cloud-echo:$(shell git describe --tags --dirty=-dev)

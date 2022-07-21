.DEFAULT_GOAL := build

export GOPRIVATE := code.cfops.it

.PHONY: build image push clean

SOURCES       := $(shell find . -name '*.go')
IMAGE         ?= registry.cfdata.org/u/$(USER)/cloud-echo
VERSION       ?= $(shell git describe --tags --always --dirty)
BUILD_FLAGS   ?= -v
LDFLAGS       ?= -w -s

build: bin/cloud-echo

bin/cloud-echo: $(SOURCES)
	CGO_ENABLED=0 go build -o $@ $(BUILD_FLAGS) -ldflags "$(LDFLAGS)"

push: image
	docker push "$(IMAGE):$(VERSION)"

image:
	docker build --rm --tag "$(IMAGE):$(VERSION)" .

clean:
	rm -rf bin

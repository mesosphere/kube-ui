# Makefile for the Docker image gcr.io/kube-ui/kube-ui
# MAINTAINER: Tim St. Clair <stclair@google.com>
# If you update this image please check the tag value before pushing.

.PHONY: all bindata container push clean

# Keep this at dev, so no one accidentally blows away the latest published version.
TAG ?= dev # current version: v5
PREFIX ?= gcr.io/google_containers
IMAGE ?= kube-ui
GCLOUD ?= gcloud

all: push

bindata: data/datafile.go
	./build/build-ui.sh

kube-ui: bindata server/kube-ui.go
	CGO_ENABLED=0 GOOS=linux godep go build -a -installsuffix cgo -ldflags '-w' ./server/kube-ui.go

container: kube-ui
	docker build -t $(PREFIX)/$(IMAGE):$(TAG) .

push: container
	docker push $(PREFIX)/$(IMAGE):$(TAG)

clean:
	rm -f kube-ui

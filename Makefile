VERSION = $(shell date +v%Y%m%d)-$(shell git describe --tags --always --dirty)

IMG = "diverdane/secretless-k8s-demo"

all: image

image:
	docker build --no-cache -t "$(IMG):$(VERSION)" .

push: image
	gcloud docker -- push "$(IMG):$(VERSION)"

.PHONY: all image push

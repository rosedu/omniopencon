IMAGE_NAME = omniopencon-site
CONTAINER_NAME = cnt-$(IMAGE_NAME)
CMD = /bin/bash

run: build
	docker run --rm --name $(CONTAINER_NAME) -v ./:/site -p 1313:1313 --interactive --tty $(IMAGE_NAME)

build:
	docker build -f Dockerfile -t $(IMAGE_NAME) .

export: cleanfs
	mkdir rootfs
	docker build -o rootfs -f Dockerfile .

cleanfs:
	-test -d rootfs && rm -fr rootfs

.PHONY: build run stop export cleanfs

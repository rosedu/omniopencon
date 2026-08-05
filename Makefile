IMAGE_NAME = omniopencon-site
CONTAINER_NAME = cnt-$(IMAGE_NAME)
CMD = /bin/bash

HUGO = docker run --rm -v ./:/site -w /site $(IMAGE_NAME) hugo

run: build
	docker run --rm --name $(CONTAINER_NAME) -v ./:/site -p 1313:1313 --interactive --tty $(IMAGE_NAME)

build:
	docker build -f Dockerfile -t $(IMAGE_NAME) .

# Build all editions (2024, 2025, 2026) into public/ with correct base URLs
# Stashes uncommitted changes to preserve 2026 content during tag checkouts
build-all: build
	# Build 2026 edition (current) first, before any git checkout
	$(HUGO) --minify --baseURL http://localhost:1313/2026/ --destination public/2026
	# Stash uncommitted changes so git checkout can work cleanly
	git stash
	# Build 2024 edition from tag
	git checkout 2024 -- config.yml static themes
	$(HUGO) --minify --baseURL http://localhost:1313/2024/ --destination public/2024
	git checkout HEAD -- config.yml static themes
	# Build 2025 edition from tag
	git checkout 2025 -- config.yml static themes
	$(HUGO) --minify --baseURL http://localhost:1313/2025/ --destination public/2025
	git checkout HEAD -- config.yml static themes
	# Restore uncommitted changes
	git stash pop
	# Create root redirect
	cp static/CNAME public/CNAME
	printf '<!DOCTYPE html>\n<html>\n<head>\n  <meta charset="utf-8">\n  <title>OmniOpenCon</title>\n  <meta http-equiv="refresh" content="0; url=/2026/">\n  <link rel="canonical" href="/2026/">\n</head>\n<body>\n  <p>Redirecting to <a href="/2026/">OmniOpenCon 2026</a>...</p>\n</body>\n</html>\n' > public/index.html

# Serve all editions from public/ using Python HTTP server
serve-all: build-all
	python3 -m http.server 1313 --directory public

export: cleanfs
	mkdir rootfs
	docker build -o rootfs -f Dockerfile .

cleanfs:
	-test -d rootfs && rm -fr rootfs

.PHONY: build run stop export cleanfs build-all serve-all

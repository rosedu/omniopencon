IMAGE_NAME = omniopencon-site
CONTAINER_NAME = cnt-$(IMAGE_NAME)

# Run Hugo inside the container as the current user so generated files are not owned by root.
DOCKER_RUN = docker run --rm --user "$(shell id -u):$(shell id -g)" -e HOME=/tmp -v ./:/site -w /site
HUGO = $(DOCKER_RUN) $(IMAGE_NAME) hugo --noBuildLock

# Live-reloading development server at http://localhost:1313/
run: build
	$(DOCKER_RUN) --name $(CONTAINER_NAME) -p 1313:1313 --interactive --tty $(IMAGE_NAME) hugo server --bind=0.0.0.0 --noBuildLock

# Build the Docker image with Hugo (extended)
build:
	docker build -f Dockerfile -t $(IMAGE_NAME) .

# Build the whole site (all editions) into public/, as deployed on GitHub Pages
build-site: build
	$(HUGO) --minify

# Build the site for a local static server (relative to http://localhost:8000/)
build-local: build
	$(HUGO) --minify --baseURL http://localhost:8000/

# Serve the static build from public/ with Python (tests the root redirect, too)
serve: build-local
	python3 -m http.server 8000 --directory public

clean:
	-rm -rf public resources/_gen

.PHONY: run build build-site build-local serve clean

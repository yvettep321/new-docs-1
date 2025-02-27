# Check if we need to prepend docker commands with sudo
SUDO := $(shell docker version >/dev/null 2>&1 || echo "sudo")

# If TAG is not provided set default value
TAG ?= stellar/developers:$(shell git rev-parse --short HEAD)$(and $(shell git status -s),-dirty-$(shell id -u -n))
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
BUILD_DATE := $(shell date --utc --rfc-3339=seconds)

docker-build:
	$(SUDO) docker build --pull --label org.opencontainers.image.created="$(BUILD_DATE)" \
	--build-arg AMPLITUDE_KEY=$(AMPLITUDE_KEY) -t $(TAG) .

docker-push:
	$(SUDO) docker push $(TAG)

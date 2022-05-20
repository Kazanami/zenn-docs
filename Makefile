MAKEFILE_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
USER_NAME=atolycs_4989
NAME=zenn-cli
VERSION=0.0.1
IMAGE_NAME=$(USER_NAME)/$(NAME):$(VERSION)
PREVIEW_CONTAINER="$(NAME)-preview"
U_ID:=$(shell id -u)
G_ID:=$(shell id -g)

build:
	docker build -t $(IMAGE_NAME) -f container/Dockerfile .

restart: stop start

start: preview

preview:
	docker run --rm -itd \
		-u $(U_ID):$(G_ID) \
		-p 8085:8000 \
		-v $(MAKEFILE_DIR)/books:/workspace/books \
		-v $(MAKEFILE_DIR)/articles:/workspace/articles \
		--name $(PREVIEW_CONTAINER) \
		$(IMAGE_NAME) npx zenn preview

stop:
	docker stop $(PREVIEW_CONTAINER)

article:
	docker run --rm -it \
		-u $(U_ID):$(G_ID) \
		-v $(MAKEFILE_DIR)/books:/workspace/books \
		-v $(MAKEFILE_DIR)/articles:/workspace/articles \
		--name $(NAME)-create \
		$(IMAGE_NAME) npx zenn new:article --slug "${BOOK_NAME}"

	

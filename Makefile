org := ashwinvis
image := latex-pandoc-python

run:
	docker run -it --rm $(org)/$(image) bash

build:
	docker build -f Dockerfile -t $(org)/$(image) .

cleancontainers:
	@echo "Clean exited containers."
	@for cont in $$(docker ps -a | awk 'NR>1{print $$1}'); do docker stop $$cont; docker rm $$cont; done

cleanimages:
	@echo "Clean dangling images with no tag."
	@for img in $$(docker images -qf "dangling=true"); do docker rmi -f $$img; done

cleanall: cleancontainers cleanimages

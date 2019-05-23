org := ashwinvis
image := latex-pandoc-python

run:
	docker run -it --rm $(org)/$(image) bash

build:
	docker build -f Dockerfile -t $(org)/$(image) .

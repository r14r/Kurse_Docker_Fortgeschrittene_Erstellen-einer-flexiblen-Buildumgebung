HERE := ${CURDIR}

CONTAINER := playground_docker

default:
	cat Makefile

build:
	docker build -t ${CONTAINER} .

clean:
	docker_rmi_all
	
run:
	docker run  -it --rm  -p 127.0.0.1:8888:8888 -v ${HERE}:/src:rw \
				-v ${HERE}/notebooks:/notebooks:rw --name ${CONTAINER} ${CONTAINER}

notebook:
	docker run  -it --rm  -p 127.0.0.1:8888:8888 -v ${HERE}:/src:rw -v ${HERE}/notebooks:/notebooks:rw --name ${CONTAINER} ${CONTAINER} bash .local/bin/run_jupyter

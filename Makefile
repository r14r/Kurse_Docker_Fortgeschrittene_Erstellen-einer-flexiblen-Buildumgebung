HERE := ${CURDIR}

CONTAINER := playground_docker

default:
	cat Makefile

build:
	docker build -t ${CONTAINER}  .

clean:
	docker stop ${CONTAINER}
	docker rm   ${CONTAINER}
	
run:
	docker run  -it --rm  -p 127.0.0.1:8888:8888 -v ${HERE}:/src:rw --name ${CONTAINER} ${CONTAINER}


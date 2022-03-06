HERE := ${CURDIR}

CONTAINER := playground_docker

default:
	cat Makefile

build:
	docker build -t ${CONTAINER} .

clean:
	docker_rmi_all
	
bash:
	docker run  -it --rm  -p 127.0.0.1:8888:8888 		\
				-v ${HERE}:/src:rw 						\
				-v ${HERE}/notebooks:/notebooks:rw		\
				--name ${CONTAINER} 					\
				${CONTAINER}							\
				/bin/bash

run:
	docker run  -it --rm  -p 127.0.0.1:8888:8888 		\
				-v ${HERE}:/src:rw						\
				-v ${HERE}/notebooks:/notebooks:rw		\
				--name ${CONTAINER}						\
				${CONTAINER} 							\
				bash .local/bin/run_jupyter

start: run

push:
	cat ~/.secure/docker_personal_access_token.txt | docker login --username r14r --password-stdin
	docker image tag playground_docker r14r/jupyter:latest
	docker push                        r14r/jupyter:latest

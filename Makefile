HERE := ${CURDIR}

CONTAINER := playground_docker
CONTAINER_FULL := playground_docker_full

default:
	cat Makefile


build_full:
	docker build -t ${CONTAINER_FULL}  -f Dockerfile.Full .

run_full:
	docker run  -it --rm  -p 127.0.0.1:8888:8888 		\
				-v ${HERE}:/src:rw						\
				-v ${HERE}/notebooks:/notebooks:rw		\
				--name ${CONTAINER_FULL}				\
				${CONTAINER_FULL} 						\
				/bin/bash

ubuntu:
	rm -rf tmp && mkdir 							tmp
	cp scripts/ubuntu/*.sh Dockerfile environment	tmp
	cd tmp && docker build -t ${CONTAINER}  --no-cache .


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

run_image:
	docker run -it --rm -p 8888:8888 -v $PWD/notebooks:/notebooks r14r/jupyter bash /home/user/.local/bin/run_jupyter


start: run

push:
	cat ~/.secure/docker_personal_access_token.txt | docker login --username r14r --password-stdin
	docker image tag playground_docker r14r/jupyter:latest
	docker push                        r14r/jupyter:latest

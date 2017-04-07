export IMAGE_NAME=rcarmo/azure-toolbox
export VCS_REF=`git rev-parse --short HEAD`
export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
base:
	docker build --build-arg VCS_REF=$(VCS_REF) \
		     --build-arg BUILD_DATE=$(BUILD_DATE) \
			 -t $(IMAGE_NAME):latest -f Dockerfile .

java:
	docker build --build-arg VCS_REF=$(VCS_REF) \
		     --build-arg BUILD_DATE=$(BUILD_DATE) \
		     -t $(IMAGE_NAME):java -f Dockerfile_java .

ml:
	docker build --build-arg VCS_REF=$(VCS_REF) \
		     --build-arg BUILD_DATE=$(BUILD_DATE) \
		     -t $(IMAGE_NAME):ml -f Dockerfile_ml .

run:
	docker run -d -p 5900:5901 $(IMAGE_NAME) /quickstart.sh

rmi:
	-docker rmi -f $(IMAGE_NAME):ml
	-docker rmi -f $(IMAGE_NAME):java
	-docker rmi -f $(IMAGE_NAME)

push:
	-docker push $(IMAGE_NAME)
	-docker push $(IMAGE_NAME):java
	-docker push $(IMAGE_NAME):ml

whole-enchilada: base java ml push

clean:
	-docker rm -v $$(docker ps -a -q -f status=exited)
	-docker rmi $$(docker images -q -f dangling=true)

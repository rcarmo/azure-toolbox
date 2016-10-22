export IMAGE_NAME=rcarmo/azure-toolbox
default:
	docker build -t $(IMAGE_NAME) -f Dockerfile \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .

java:
	docker build -t $(IMAGE_NAME):java -f Dockerfile_java .

run:
	docker run -d -p 5900:5901 $(IMAGE_NAME) /quickstart.sh

rmi:
	docker rmi -f $(IMAGE_NAME)

push:
	-docker push $(IMAGE_NAME)
	-docker push $(IMAGE_NAME):java

clean:
	-docker rm -v $$(docker ps -a -q -f status=exited)
	-docker rmi $$(docker images -q -f dangling=true)
	-docker rmi $(IMAGE_NAME)

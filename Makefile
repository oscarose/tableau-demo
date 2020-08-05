EDITOR=vim

all: regconfig build

build:
	docker build -t tableau:2.3.4 .

run: build
	docker run -ti --privileged -v /sys/fs/cgroup:/sys/fs/cgroup -v /run -p 8850:8850 tableau:2.3.4


clean:
	docker system prune
	
prune:
	docker system prune -f

exec:
	docker exec -ti `docker ps | grep tableau:2.3.4 |head -1 | awk -e '{print $$1}'` /bin/bash


config/registration_file.json: 
	cp config/registration_file.json.templ config/registration_file.json
	$(EDITOR) config/registration_file.json

regconfig: config/registration_file.json

stop:
	docker stop `docker ps | grep tableau:2.3.4 |head -1| awk -e '{print $$1}'`


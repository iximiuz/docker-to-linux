COL_RED="\033[0;31m"
COL_GRN="\033[0;32m"
COL_END="\033[0m"

UNAME_S := $(shell uname -s)
LOOPDEVICE := /dev/boot0
ifeq ($(UNAME_S),Linux)
    LOOPDEVICE := $(shell losetup -f)
endif
ifeq ($(UNAME_S),Darwin)
	LOOPDEVICE := $(shell echo 'losetup -f' |\
    	docker run -i --rm --privileged --pid=host justincormack/nsenter1)
endif

REPO=docker-to-linux


.PHONY:
debian: debian.img

.PHONY:
ubuntu: ubuntu.img

.PHONY:
alpine: alpine.img

.PHONY:
raspbian: raspbian.img

.PHONY:
debian.tar:
	@make DISTR="debian" linux.tar

.PHONY:
debian.img:
	@make DISTR="debian" linux.img

.PHONY:
ubuntu.tar:
	@make DISTR="ubuntu" linux.tar

.PHONY:
ubuntu.img:
	@echo $(LOOPDEVICE)
	@make DISTR="ubuntu" linux.img

.PHONY:
alpine.tar:
	@make DISTR="alpine" linux.tar

.PHONY:
alpine.img:
	@make DISTR="alpine" linux.img

.PHONY:
raspbian.tar:
	@make DISTR="raspbian" linux.tar

.PHONY:
raspbian.img:
	@make DISTR="raspbian" linux.img

linux.tar:
	@echo ${COL_GRN}"[Dump ${DISTR} directory structure to tar archive]"${COL_END}
	docker build -f ${DISTR}/Dockerfile -t ${REPO}/${DISTR} .
	docker export -o linux.tar `docker run -d ${REPO}/${DISTR} /bin/true`

linux.dir: linux.tar
	@echo ${COL_GRN}"[Extract ${DISTR} tar archive]"${COL_END}
	mkdir linux.dir
	tar -xvf linux.tar -C linux.dir || echo "Ignoring tar error"

linux.img: builder linux.dir
	@echo ${COL_GRN}"[Create ${DISTR} disk image]"${COL_END}
	docker run \
		-v `pwd`:/os:rw \
		-e DISTR=${DISTR} \
		--privileged \
		--cap-add SYS_ADMIN \
		--device $(LOOPDEVICE) \
		${REPO}/builder bash /os/create_image.sh $(LOOPDEVICE)

.PHONY:
builder:
	@echo ${COL_GRN}"[Ensure builder is ready]"${COL_END}
	@if [ "`docker images -q ${REPO}/builder`" = '' ]; then\
		docker build -f Dockerfile -t ${REPO}/builder .;\
	fi

.PHONY:
builder-interactive:
	docker run -it \
		-v `pwd`:/os:rw \
		--cap-add SYS_ADMIN \
		--device $(LOOPDEVICE) \
		${REPO}/builder bash

.PHONY:
clean: clean-docker-procs clean-docker-images
	@echo ${COL_GRN}"[Remove leftovers]"${COL_END}
	rm -rf mnt linux.tar linux.dir linux.img linux.vdi

.PHONY:
clean-docker-procs:
	@echo ${COL_GRN}"[Remove Docker Processes]"${COL_END}
	@if [ "`docker ps -qa -f=label=com.iximiuz-project=${REPO}`" != '' ]; then\
		docker rm `docker ps -qa -f=label=com.iximiuz-project=${REPO}`;\
	else\
		echo "<noop>";\
	fi

.PHONY:
clean-docker-images:
	@echo ${COL_GRN}"[Remove Docker Images]"${COL_END}
	@if [ "`docker images -q ${REPO}/*`" != '' ]; then\
		docker rmi `docker images -q ${REPO}/*`;\
	else\
		echo "<noop>";\
	fi


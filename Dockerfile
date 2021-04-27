FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic
ENV DEBIAN_FRONTEND="noninteractive" 	


COPY bottorrent.py /app/bottorrent.py
COPY requirements.txt requirements.txt
COPY root/ /
RUN chmod 777 /app/bottorrent.py 

# install packages
RUN apt-get update && \
 apt-get install -y --no-install-recommends \
	python3 \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python3-wheel \
	build-essential && \
 usermod -d /app abc && \
	python3 -m pip install --upgrade pip && \
	pip3 install -r requirements.txt  && \
	apt-get remove --purge -y build-essential && \
	# cleanup
 apt-get autoclean -y && apt-get autoremove -y && \
 rm -rf \
	/config/ \
	/default/ \
	/etc/default/ \
	/tmp/* \
	/etc/cont-init.d/* \
	/var/lib/apt/lists/* \
	/var/tmp/* 





WORKDIR /app
VOLUME /download /watch

#ENTRYPOINT ["/app/bottorrent.py"]

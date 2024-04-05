#FROM jsavargas/telethon_downloader:ffmpeg AS basetelethon
FROM python:3.9-slim-bullseye AS basetelethon

WORKDIR /app

RUN sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list

RUN apt-get -q update 
RUN apt-get -qy dist-upgrade
RUN apt-get install -qy curl unrar unzip python3-pip

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="$PATH:/root/.cargo/bin"

RUN rustc --version

COPY requirements.txt requirements.txt

RUN python3 -m pip install --upgrade pip  && \
    pip3 install --upgrade -r requirements.txt 
    
RUN apt-get remove --purge -y build-essential  && \
    apt-get autoclean -y && apt-get autoremove -y 

RUN rm -rf /default /etc/default /tmp/* /etc/cont-init.d/* /var/lib/apt/lists/* /var/tmp/*

FROM basetelethon

COPY telethon-downloader /app

RUN chmod 777 /app/bottorrent.py

VOLUME /download /watch /config

CMD ["python3", "/app/bottorrent.py"]

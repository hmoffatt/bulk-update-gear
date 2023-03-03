FROM docker.io/library/debian:bullseye
ARG S6_OVERLAY_VERSION=3.1.4.1

ENV FLASK_ENV=development
ENV STRAVA_CLIENT_ID=
ENV STRAVA_CLIENT_SECRET=
ENV URL=http://localhost:5000/

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENV APP_SECRET_KEY=f4f25799396972e43a45b204c80adb5f9fad29017a28f4e0e0e8644852e0d8c1

RUN apt-get update && apt-get install -y python3 redis-server pipenv

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

ADD . /app
RUN cd /app && pipenv install

RUN mv /app/docker/etc/* /etc/

ENTRYPOINT ["/init"]

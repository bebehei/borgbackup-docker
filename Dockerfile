FROM alpine:3.7

ARG BORG_VERSION=1.1.3

RUN true \
 && apk add --no-cache \
      acl \
      openssh \
      openssl \
      py3-lz4 \
      python3 \
 && apk add --no-cache --virtual .deps \
      acl-dev \
      alpine-sdk \
      git \
      linux-headers \
      lz4-dev \
      openssl-dev \
      python3-dev \
 && git clone https://github.com/borgbackup/borg.git /srv/borg \
 && git -C /srv/borg checkout ${BORG_VERSION} \
# shutil cannot copy CHANGES.rst, as it is a symlink
# See https://github.com/docker-library/python/issues/155
 && rm /srv/borg/CHANGES.rst \
 && python3 -m pip install Cython \
 && python3 -m pip install /srv/borg \
 && python3 -m pip uninstall -y Cython \
 && cp -r /etc/ssh /etc/ssh.sav \
 && apk del .deps \
 && rm -rf \
      /etc/motd \
      /var/cache/apk/* \
      /srv/borg \
 && true

ADD docker.sh /srv/docker-entry

EXPOSE 22

ENTRYPOINT ["/srv/docker-entry"]
CMD ["/usr/sbin/sshd", "-D", "-e"]

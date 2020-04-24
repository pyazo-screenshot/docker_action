FROM archlinux:latest

WORKDIR /data
ENTRYPOINT ["/entrypoint.sh"]

RUN pacman -Sy --noconfirm jq && chown 1000: /data
USER 1000:1000
COPY entrypoint.sh /entrypoint.sh

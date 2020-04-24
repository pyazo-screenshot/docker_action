FROM archlinux:latest

ENTRYPOINT ["/entrypoint.sh"]
RUN pacman -Sy --noconfirm jq

USER 1000:1000
COPY entrypoint.sh /entrypoint.sh

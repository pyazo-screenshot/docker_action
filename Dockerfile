FROM archlinux:latest

WORKDIR /github/workspace
ENTRYPOINT ["/entrypoint.sh"]

RUN pacman -Sy --noconfirm jq binutils git openssh && useradd -m -U user

COPY entrypoint.sh /entrypoint.sh

FROM archlinux:latest

WORKDIR /github/workspace
ENTRYPOINT ["/entrypoint.sh"]

RUN pacman -Sy --noconfirm jq binutils git openssh && useradd -m -U user && chown user:user /github/workspace
USER user:user

COPY entrypoint.sh /entrypoint.sh

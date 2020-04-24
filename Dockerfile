FROM archlinux:latest

USER 1000:1000
ENTRYPOINT ["/entrypoint.sh"]

COPY entrypoint.sh /entrypoint.sh

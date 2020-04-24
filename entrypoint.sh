#!/bin/bash

pacman -Sy jq
REF=$(echo $1 | sed "s#\(refs/tags/\)\?v\?##")
while true; do
  SHA256=$(curl -sSL https://pypi.org/pypi/pyazo-cli/json | jq -r ".releases[\"$REF\"][1].digests.sha256")
  if [ "$SHA256" != "null" ]; then
    break
  fi
done
sed -i "s/^sha256sums=('.\+/sha256sums=('$SHA256/" PKGBUILD
sed -i "s/^pkgver=('.\+/pkgver=('$REF/" PKGBUILD
makepkg --printsrcinfo > .SRCINFO
cat PKGBUILD
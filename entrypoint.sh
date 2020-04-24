#!/bin/bash

set -e
mkdir -p /root/.ssh
echo $2 > /root/.ssh/id_ed25519
echo -e "Host aur.archlinux.org\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*

REF=$(echo $1 | sed "s#\(refs/tags/\)\?v\?##")
while true; do
  SHA256=$(curl -sSL https://pypi.org/pypi/pyazo-cli/json | jq -r ".releases[\"$REF\"][1].digests.sha256")
  if [ "$SHA256" != "null" ]; then
    break
  fi
done

sed -i "s/^sha256sums=('.\+/sha256sums=('$SHA256')/" PKGBUILD
sed -i "s/^pkgver='.\+/pkgver='$REF'/" PKGBUILD

cp $PWD/PKGBUILD /tmp
cd /tmp
chown user:user /tmp/PKGBUILD
su -c "makepkg --printsrcinfo" user > .SRCINFO
cd -
cp /tmp/.SRCINFO .

git config --global user.email "jelena.dpk@gmail.com"
git config --global user.name "JRubics"
git add .
git commit -m "$REF version on aur"
git remote add aur aur@aur.archlinux.org:pyazo-cli
git push aur master
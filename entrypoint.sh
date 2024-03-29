#!/bin/bash

set -e

mkdir -p /root/.ssh
echo $2 > /root/.ssh/id_ed25519
echo -e "Host aur.archlinux.org\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
chown -R root:root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
sed -i "s#|#\n#g" /root/.ssh/id_ed25519

git config --global --add safe.directory /github/workspace
git config --global --add safe.directory /github/workspace/aur
git config --global user.email "jelena.dpk@gmail.com"
git config --global user.name "JRubics"

git submodule init
git submodule update

cd aur
git pull origin master
git checkout master

REF=$(echo $1 | sed "s#\(refs/tags/\)\?v\?##")
while true; do
    release=$(curl -sSL https://pypi.org/pypi/pyazo-cli/json | jq -r ".releases[\"$REF\"][0]")
    SHA256=$(echo $release | jq -r ".digests.sha256")
    URL=$(echo $release | jq -r ".url")
    if [ "$SHA256" != "null" ]; then
        break
    fi
done

sed -i "s/^sha256sums=('.\+/sha256sums=('$SHA256')/" PKGBUILD
sed -i "s/^pkgver='.\+/pkgver='$REF'/" PKGBUILD
sed -i "s/^source=('.\+/source=('$URL')/" PKGBUILD

cp $PWD/PKGBUILD /tmp
cd /tmp
chown user:user /tmp/PKGBUILD
su -c "makepkg --printsrcinfo" user > .SRCINFO
cd -
cp /tmp/.SRCINFO .

git add .
git commit -m "$REF version on aur"
git push origin master

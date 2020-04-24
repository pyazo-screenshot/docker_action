#!/bin/bash

set -e
mkdir -p /home/user/.ssh
echo $2 > /home/user/.ssh/id_ed25519

REF=$(echo $1 | sed "s#\(refs/tags/\)\?v\?##")
while true; do
  SHA256=$(curl -sSL https://pypi.org/pypi/pyazo-cli/json | jq -r ".releases[\"$REF\"][1].digests.sha256")
  if [ "$SHA256" != "null" ]; then
    break
  fi
done

cp -r /github/workspace /tmp/workspace
cd /tmp/workspace
sed -i "s/^sha256sums=('.\+/sha256sums=('$SHA256')/" PKGBUILD
sed -i "s/^pkgver='.\+/pkgver='$REF'/" PKGBUILD
chown -R user:user /tmp/workspace
su -c "makepkg --printsrcinfo" user > .SRCINFO
cd -
cp /tmp/workspace/.SRCINFO .

ls -la
cat PKGBUILD
cat .SRCINFO
exit

git config --global user.email "jelena.dpk@gmail.com"
git config --global user.name "JRubics"
git add .
git commit -m "$REF version on aur"
git remote add aur aur@aur.archlinux.org:pyazo-cli
git push aur master
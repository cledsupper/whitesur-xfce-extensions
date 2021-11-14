#!/usr/bin/env bash

wget --version > /dev/null
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Downloading macbuntu-os-ithemes-v1804_3.3~bionic~NoobsLab.com_all.deb from Launchpad.net..."
tries=0
err=1
while ( [ $err -eq 1 ] && [ $tries -lt 3 ] ); do
  tries=$(($tries+1))
  wget -c "https://launchpad.net/~noobslab/+archive/ubuntu/macbuntu/+files/macbuntu-os-ithemes-v1804_3.3~bionic~NoobsLab.com_all.deb"
  if [ $? -eq 0 ]; then
    err=0
  else
    echo "Trying again..."
  fi
done

echo "Check file integrity..."
MD5SUM=$(md5sum macbuntu-os-ithemes-v1804_3.3~bionic~NoobsLab.com_all.deb | grep -Eo "^[a-f0-9]+")
if ( [ $tries -eq 3 ] || [ "$MD5SUM" != "6ea1c15890cfa4c4e10c8c0b21ac8f1b" ] ); then
  echo "Failed to download package! Verify your internet connection and try again"
  exit 1
fi

echo "Extracting deb package..."
dpkg --extract "macbuntu-os-ithemes-v1804_3.3~bionic~NoobsLab.com_all.deb" ./

echo "Copying \"unity\" folder to \"WhiteSur\" and \"WhiteSur-dark\""
cp -r ./usr/share/themes/MacBuntu-XFCEMateCinnamon-O/unity WhiteSur/unity
cp -r ./usr/share/themes/MacBuntu-XFCEMateCinnamon-O/unity WhiteSur-dark/unity

echo "Removing temporary files..."
rm -r ./usr
rm "macbuntu-os-ithemes-v1804_3.3~bionic~NoobsLab.com_all.deb"

echo "by cleds.upper"

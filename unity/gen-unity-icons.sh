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

if ( [ $tries -eq 3 ] || ! ( [ -r "macbuntu-os-ithemes-v1804_3.3~bionic~NoobsLab.com_all.deb" ] ) ); then
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

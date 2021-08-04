#!/usr/bin/env bash

echo "Generating panel configuration..."

icon_folders=(
  "$HOME/.icons"
  "/usr/share/icons"
  "/usr/local/share/icons"
)
for i in ${icon_folders[@]}; do
  if [ -d "$i/WhiteSur-dark" ]; then
    THEME_DIR="$i/WhiteSur-dark"
    break
  fi
done

if [ "$THEME_DIR" = "" ]; then
  echo "Icon theme not found!"
  exit 1
fi

rm "launcher-14/2.desktop"
rm lesso*.tar.bz2
mkdir -p launcher-14

echo "[Desktop Entry]
Version=1.0
Type=Application
Name[pt_BR]=Pesquisa Synapse
Name[pt]=Pesquisa Synapse
Name=Synapse Search
Comment[pt_BR]=Busque em tudo que você faz.
Comment[pt]=Procure tudo aquilo que faz.
Comment=Search everything you do.
Exec=synapse
Icon=$THEME_DIR/places/symbolic/folder-saved-search-symbolic.svg
Path=
Terminal=false
StartupNotify=true"\
  >> "launcher-14/2.desktop"

rm *.tar.bz2
mv config-light.txt config.txt
tar -cvjSf lesso-whitesur-light.tar.bz2 launcher-14 launcher-2 config.txt
mv config.txt config-light.txt
mv config-dark.txt config.txt
tar -cvjSf lesso-whitesur-dark.tar.bz2 launcher-14 launcher-2 config.txt
mv config.txt config-dark.txt

echo "Open your panel preferences and apply configuration from a backup file"
echo "by cleds.upper"

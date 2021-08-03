#!/usr/bin/env bash

readonly SCRIPT=$0
readonly WALL=$1
readonly THEME="WhiteSur"
readonly DIR_WALLPAPER=$2

readonly H_LIGHT_BEG=5
readonly H_LIGHT_END=12
readonly H_AFTER_BEG=11
readonly H_AFTER_END=18

mode="light"

./themeset.sh check-only $THEME ign $DIR_WALLPAPER
ret=$?
if [ $ret -ne 0 ]; then
  exit $ret
fi

function refresh_mode {
  hours=$1
  if ( [ $hours -gt $H_LIGHT_BEG ] && [ $hours -lt $H_LIGHT_END ] ); then
    mode="light"
  elif ( [ $hours -gt $H_AFTER_BEG ] && [ $hours -lt $H_AFTER_END ] ); then
    mode="afternoon"
  else
    mode="dark"
  fi
}

prevMode="none"
function update_themes {
  echo "Updating system theme to $mode mode..."
  case $WALL in
    W|T)
      ./themeset.sh $WALL "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    WT)
      ./themeset.sh A "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    WP)
      ./themeset.sh W "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ./panelset.sh $mode
      ;;

    TP)
      ./themeset.sh T "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ./panelset.sh $mode
      ;;

    A)
      ./themeset.sh A "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ./panelset.sh $mode
  esac
}

timedatectl status 1> /dev/null
if [ $? -ne 0 ]; then
  exit 1
fi

# readonly FILTER="(:[0-9]{2}[^:])|(:[0-9]{2}$)"
readonly FILTER="[0-9]{2}:"

hours=$(timedatectl | grep -m 1 -i "local" | grep -E -o "$FILTER" | grep -E -o -m 1 "[0-9]+")
refresh_mode $hours

while [ 0 ]; do
  sleep 1;

  hours=$(timedatectl status | grep -m 1 -i "local" | grep -E -o "$FILTER" | grep -E -o -m 1 "[0-9]+")
  refresh_mode $hours

  if [ "$mode" != "$prevMode" ]; then
    prevMode=$mode
    update_themes
  fi
done

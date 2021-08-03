#!/usr/bin/env bash

readonly SCRIPT=$0
readonly WALL=$1
readonly THEME="WhiteSur"
readonly DIR_WALLPAPER=$2

readonly THEMESET_PATH="$HOME/opt/themed/themeset.sh"
readonly PANELSET_PATH="$HOME/opt/themed/panelset.sh"

readonly H_LIGHT_BEG=5
readonly H_LIGHT_END=12
readonly H_AFTER_BEG=11
readonly H_AFTER_END=18

mode="light"

$THEMESET_PATH check-only $THEME ign $DIR_WALLPAPER
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
      $THEMESET_PATH $WALL "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    WT)
      $THEMESET_PATH A "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    WP)
      $THEMESET_PATH W "$THEME" $mode "$DIR_WALLPAPER" nocheck
      $PANELSET_PATH $mode
      ;;

    TP)
      $THEMESET_PATH T "$THEME" $mode "$DIR_WALLPAPER" nocheck
      $PANELSET_PATH $mode
      ;;

    A)
      $THEMESET_PATH A "$THEME" $mode "$DIR_WALLPAPER" nocheck
      $PANELSET_PATH $mode
  esac
}

timedatectl status 1> /dev/null
if [ $? -ne 0 ]; then
  exit 1
fi

# readonly FILTER="(:[0-9]{2}[^:])|(:[0-9]{2}$)"
readonly FILTER="[0-9]{2}:"

function on_term {
  exit 0
}

trap on_term SIGTERM
trap on_term SIGINT
trap on_term SIGHUP

while [ 0 ]; do
  sleep 60;

  hours=$(timedatectl status | grep -m 1 -i "local" | grep -E -o "$FILTER" | grep -E -o -m 1 "[0-9]+")
  refresh_mode $hours

  if [ "$mode" != "$prevMode" ]; then
    prevMode=$mode
    update_themes
  fi
done

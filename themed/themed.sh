#!/usr/bin/env bash

#############################################
#     themed - Theme Daemon for XFCE 4      #
#               version 0.2                 #
#                                           #
# by cleds.upper                            #
# mastodon.technology/@cledson_cavalcanti   #
#############################################

readonly SCRIPT=$0
WALL=$1
readonly THEME="WhiteSur"
readonly DIR_WALLPAPER=$2

readonly THEMESET_PATH="$HOME/opt/themed/themeset.sh"
readonly PANELSET_PATH="$HOME/opt/themed/panelset.sh"

readonly H_LIGHT_BEG=5
readonly H_LIGHT_END=12
readonly H_AFTER_BEG=11
readonly H_AFTER_END=18

mode="light"

## CHECK DEPENDENCIES

timedatectl status 1> /dev/null
if [ $? -ne 0 ]; then
  exit 1
fi

test -x $THEMESET_PATH
if [ $? -ne 0 ]; then
  exit 1
fi

test -x $PANELSET_PATH
if [ $? -ne 0 ]; then
  exit 1
fi


## CHECK IF THEMES AND FILES ARE AVAILABLE

$THEMESET_PATH check-only $THEME ign $DIR_WALLPAPER
errors=$?
if ( [ $errors -eq 3 ] || [ $errors -eq 11 ] ); then
  # Exit when wallpaper(1)+GTK(2)+(+panel(8)) errors are turned on
  exit $errors
fi

$PANELSET_PATH check-only
export CheckErrors=$(($errors|$?))


# Set mode according with time
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

    WT|TW)
      $THEMESET_PATH A "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    P)
      $PANELSET_PATH $mode
      ;;

    WP|PW)
      $PANELSET_PATH $mode
      $THEMESET_PATH W "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    TP|PT)
      $PANELSET_PATH $mode
      $THEMESET_PATH T "$THEME" $mode "$DIR_WALLPAPER" nocheck
      ;;

    A)
      $PANELSET_PATH $mode
      $THEMESET_PATH A "$THEME" $mode "$DIR_WALLPAPER" nocheck
  esac
}

#readonly FILTER="(:[0-9]{2}[^:])|(:[0-9]{2}$)"
readonly FILTER="[0-9]{2}:"

# change process name
printf themed > /proc/self/comm


## SERVICE RUNNING

while [ 0 ]; do
  sleep 60;

  hours=$(timedatectl status | grep -m 1 -i "local" | grep -E -o "$FILTER" | grep -E -o -m 1 "[0-9]+")
  refresh_mode $hours

  if [ "$mode" != "$prevMode" ]; then
    prevMode=$mode
    update_themes
  fi
done

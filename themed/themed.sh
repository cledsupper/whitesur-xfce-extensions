#!/usr/bin/env bash

#############################################
#     themed - Theme Daemon for XFCE 4      #
#               version 0.2                 #
#                                           #
# by cleds.upper                            #
# mastodon.technology/@cledson_cavalcanti   #
#############################################

readonly SCRIPT=$0
readonly WALL=$1
readonly THEME="WhiteSur"
readonly DIR_WALLPAPER=$2

if [ "$THEMED_PATH" = "" ]; then
  readonly THEMESET_PATH="$HOME/opt/themed/themeset.sh"
  readonly PANELSET_PATH="$HOME/opt/themed/panelset.sh"
else
  readonly THEMESET_PATH="$THEMED_PATH/themeset.sh"
  readonly PANELSET_PATH="$THEMED_PATH/panelset.sh"
fi

readonly H_LIGHT_BEG=6
readonly H_LIGHT_END=12
readonly H_AFTER_BEG=12
readonly H_AFTER_END=18

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

readonly E_WALLPAPER=1
readonly E_THEME_GTK=2
readonly E_THEME_ICON=4
readonly E_PANEL=8

$THEMESET_PATH --check-only -t "$THEME" -w "$THEME" "$DIR_WALLPAPER"
errors=$?
if ( [ $errors -eq 3 ] || [ $errors -eq 255 ] ); then
  # Exit when there are fatal errors
  exit $errors
fi

$PANELSET_PATH check-only
errors=$(($errors|$?))
if [ $errors -eq 8 ]; then
  exit 8
fi
export THEMED_ERRORS=$errors


# Set mode according with time
function refresh_mode {
  hours=$1
  if ( [ $hours -ge $H_LIGHT_BEG ] && [ $hours -lt $H_LIGHT_END ] ); then
    mode="light"
  elif ( [ $hours -ge $H_AFTER_BEG ] && [ $hours -lt $H_AFTER_END ] ); then
    mode="afternoon"
  else
    mode="dark"
  fi
}

prevMode="none"
function update_themes {
  echo "Updating system theme to $mode mode..."
  case $WALL in
    W)
      $THEMESET_PATH -m "$mode" -w "$THEME" "$DIR_WALLPAPER" --no-check
      ;;

    T)
      $THEMESET_PATH -m "$mode" -t "$THEME" --no-check
      ;;

    WT|TW)
      $THEMESET_PATH -t "$THEME" $mode -w "$THEME" "$DIR_WALLPAPER" --no-check
      ;;

    P)
      $PANELSET_PATH $mode
      ;;

    WP|PW)
      $PANELSET_PATH $mode
      $THEMESET_PATH -m "$mode" -w "$THEME" "$DIR_WALLPAPER" --no-check
      ;;

    TP|PT)
      $PANELSET_PATH $mode
      $THEMESET_PATH -m "$mode" -t "$THEME" --no-check
      ;;

    A)
      $PANELSET_PATH $mode
      $THEMESET_PATH -m "$mode" -t "$THEME" -w "$THEME" "$DIR_WALLPAPER" --no-check
  esac
}

#readonly FILTER="(:[0-9]{2}[^:])|(:[0-9]{2}$)"
readonly FILTER="[0-9]{2}:"

# change process name
printf themed > /proc/$$/comm


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

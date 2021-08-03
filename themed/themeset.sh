#!/usr/bin/env bash

readonly SCRIPT=$0
readonly WALL=$1
readonly THEME=$2
readonly THEME_MODE=$3
readonly DIR_WALLPAPER=$4
NOCHECK=1
if [ "$5" = "nocheck" ]; then
  NOCHECK=0
fi

readonly FILENAME_ENDING=$(ls $DIR_WALLPAPER | grep -i -E -o -m 1 "\.[a-z]{3}")

# This may change according to each device
readonly PROP_WALLPAPER="/backdrop/screen0/monitoreDP-1/workspace0/last-image"

# LOG COMMANDS INSTEAD OF EXECUTING
readonly DEBUG_MODE=1
echoIt=""
if [ $DEBUG_MODE -eq 1 ]; then
  echoIt="echo"
fi

WALLPAPER_LIGHT="$DIR_WALLPAPER/$THEME-light$FILENAME_ENDING"
WALLPAPER_AFTERNOON="$DIR_WALLPAPER/$THEME$FILENAME_ENDING"
WALLPAPER_DARK="$DIR_WALLPAPER/$THEME-dark$FILENAME_ENDING"

function help {
  echo "USAGE: $SCRIPT <W|T|A(ll)> <\"MyTheme\"> <afternoon|dark|light> [\"/path/to/wallpapers/\"]"
  echo
  echo "1. W|T|All: select (W)allpaper, (T)heme or both (A)"
  echo "2. \"MyTheme\": must be theme/wallpaper name"
  echo "3. Select variant for theme or wallpaper"
  echo "4. Type the path to wallpapers [optional]"
  exit 1
}


IgnGtkTheme=0
IgnIconTheme=0
IgnWallpapers=0

## CHECK IF WALLPAPERS AND XFCONF PATH DO EXIST
function wallpapers_check {
  if [ $NOCHECK -eq 0 ]; then
    return 0
  fi

  echo "Checking for xfce4-desktop wallpaper property..."
  xfconf-query -c xfce4-desktop -p $PROP_WALLPAPER 1> /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "xfce4-desktop's wallpaper property not found!"
    IgnWallpapers=1
    return 1
  fi

  pfile=(
    "$WALLPAPER_LIGHT"
    "$WALLPAPER_AFTERNOON"
    "$WALLPAPER_DARK"
  )

  for i in ${pfile[@]}; do
    echo "Checking file \"$i\"..."
    test -r "$i"
    if [ $? -ne 0 ]; then
      echo "File couldn't be read!"
      IgnWallpapers=1
      return 2
    fi
  done

  echo

  return 0
}

## CHECK IF THEMES DO EXIST
function themes_check {
  if [ $NOCHECK -eq 0 ]; then
    return 0
  fi

  theme_folders=(
    "$HOME/.themes"
    "/usr/local/share/themes"
    "/usr/share/themes"
  )
  icon_folders=(
    "$HOME/.icons"
    "/usr/local/share/icons"
    "/usr/share/icons"
  )

  echo "Checking theme folders..."
  found=0
  for f in ${theme_folders[@]}; do

    if [ -d "$f/$THEME" ]; then
      # Check for presence of xfwm4
      if [ -d "$f/$THEME/xfwm4" ]; then
        found=$(($found+1))
      else
        echo "xfwm4 theme not found!"
        return 1
      fi

      if [ -d "$f/$THEME-dark" ]; then
        if [ -d "$f/$THEME-dark/xfwm4" ]; then
          found=$(($found+1))
        else
          echo "xfwm4 dark theme not found!"
          return 1
        fi
      fi
    fi

    if ( [ $found -ne 0 ] && [ $found -eq 1 ] ); then
      echo "GTK theme doesn't have a light/dark variant!"
      IgnGtkTheme=1
      return 1
    fi
  done

  # Check if icon theme folders with $THEME name exists
  found=0
  for f in ${icon_folders[@]}; do

    if [ -d "$f/$THEME" ]; then
      found=$(($found+1))

      if [ -d "$f/$THEME-dark" ]; then
        found=$(($found+1))
      fi
    fi

    if [ $found -ne 2 ]; then
      echo "Icon theme doesn't have a light/dark variant!"
      IgnIconTheme=1
      break
    fi
  done

  echo

  return 0
}

function set_theme {
  mode=$1
  themes_check
  if [ $? -ne 0 ]; then
    return 1
  fi

  echo "Apply $mode variant for $THEME theme"

  case $mode in
    dark)
      $echoIt xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME-dark"
      if [ $IgnIconTheme -eq 0 ]; then
        $echoIt xfconf-query -c xsettings -p /Net/IconThemeName -s "$THEME-dark"
      fi
      $echoIt xfconf-query -c xfwm4 -p /general/theme -s "$THEME-dark"
      ;;

    light|afternoon)
      $echoIt xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME"
      if [ $IgnIconTheme -eq 0 ]; then
        $echoIt xfconf-query -c xsettings -p /Net/IconThemeName -s "$THEME"
      fi
      $echoIt xfconf-query -c xfwm4 -p /general/theme -s "$THEME"
      ;;

    *)
      help
  esac

  return 0
}

function set_wallpaper {
  mode=$1
  wallpapers_check
  if [ $? -ne 0 ]; then
    return 1
  fi

  echo "Set wallpaper to $mode mode"

  case $mode in
    dark)
      $echoIt xfconf-query -c xfce4-desktop -p $PROP_WALLPAPER -s "$WALLPAPER_DARK"
      ;;
    afternoon)
      $echoIt xfconf-query -c xfce4-desktop -p $PROP_WALLPAPER -s "$WALLPAPER_AFTERNOON"
      ;;
    light)
      $echoIt xfconf-query -c xfce4-desktop -p $PROP_WALLPAPER -s "$WALLPAPER_LIGHT"
      ;;
    *)
      help
  esac
}

case $1 in
  W)
    set_wallpaper $3
    ;;

  T)
    set_theme $3
    ;;

  A)
    set_wallpaper $3
    set_theme $3
    ;;

  check-only)
    wallpapers_check
    ret=$?
    if [ $ret -ne 0 ]; then
      exit $ret
    fi

    themes_check
    ret=$?
    if [ $ret -ne 0 ]; then
      exit $ret
    fi
    ;;

  config)
    ;;

  *)
    help
esac

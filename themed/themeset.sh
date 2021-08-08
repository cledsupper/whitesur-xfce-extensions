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

## ERRORS BITWISE
readonly E_WALLPAPER=1
readonly E_THEME_GTK=2
readonly E_THEME_ICON=4

if [ "$CheckErrors" = "" ]; then
  CheckErrors=0

  if [ -d $DIR_WALLPAPER ]; then
    readonly FILENAME_ENDING=$(ls $DIR_WALLPAPER | grep -i -E -o -m 1 "\.[a-z]{3}")
    WALLPAPER_LIGHT="$DIR_WALLPAPER/$THEME-light$FILENAME_ENDING"
    WALLPAPER_AFTERNOON="$DIR_WALLPAPER/$THEME$FILENAME_ENDING"
    WALLPAPER_DARK="$DIR_WALLPAPER/$THEME-dark$FILENAME_ENDING"
  else
    CheckErrors=1
  fi
elif [ $(($CheckErrors&E_WALLPAPER)) -eq 0 ]; then
  readonly FILENAME_ENDING=$(ls $DIR_WALLPAPER | grep -i -E -o -m 1 "\.[a-z]{3}")
  WALLPAPER_LIGHT="$DIR_WALLPAPER/$THEME-light$FILENAME_ENDING"
  WALLPAPER_AFTERNOON="$DIR_WALLPAPER/$THEME$FILENAME_ENDING"
  WALLPAPER_DARK="$DIR_WALLPAPER/$THEME-dark$FILENAME_ENDING"
fi

# LOG COMMANDS INSTEAD OF EXECUTING
readonly DEBUG_MODE=0
echoIt=""
if [ $DEBUG_MODE -eq 1 ]; then
  echoIt="echo"
fi

# This may change according to each device
readonly PROP_WALLPAPER="/backdrop/screen0/monitoreDP-1/workspace0/last-image"

function help {
  echo "USAGE: $SCRIPT <W|T|A(ll)> <\"MyTheme\"> <afternoon|dark|light> [\"/path/to/wallpapers/\"]"
  echo
  echo "1. W|T|All: select (W)allpaper, (T)heme or both (A)"
  echo "2. \"MyTheme\": must be theme/wallpaper name"
  echo "3. Select variant for theme or wallpaper"
  echo "4. Type the path to wallpapers [optional]"
  exit 1
}

## CHECK IF WALLPAPERS AND XFCONF PATH DO EXIST
function wallpapers_check {
  if [ $NOCHECK -eq 0 ]; then
    return 0
  fi

  printf "Checking for xfce4-desktop wallpaper property... "
  xfconf-query -c xfce4-desktop -p $PROP_WALLPAPER 1> /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "fail!"
    echo "xfce4-desktop's wallpaper property not found!"
    echo
    CheckErrors=$(($CheckErrors|$E_WALLPAPER))
    return 1
  fi
  echo "ok!"

  pfile=(
    "$WALLPAPER_LIGHT"
    "$WALLPAPER_AFTERNOON"
    "$WALLPAPER_DARK"
  )

  for i in ${pfile[@]}; do
    printf "Checking for wallpaper file \"$i\"... "
    test -r "$i"
    if [ $? -ne 0 ]; then
      echo "fail!"
      echo "File couldn't be read!"
      echo
      CheckErrors=$(($CheckErrors|$E_WALLPAPER))
      return 1
    fi
    echo "ok!"
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

  printf "Checking GTK theme folders... "
  found=0
  for f in ${theme_folders[@]}; do

    if [ -d "$f/$THEME" ]; then

      # Check for presence of xfwm4
      if [ -d "$f/$THEME/xfwm4" ]; then
        found=$(($found+1))
      else
        echo "fail!"
        echo "xfwm4 theme not found!"
        echo
        CheckErrors=$(($CheckErrors|$E_THEME_GTK))
        return 1
      fi

      if [ -d "$f/$THEME-dark" ]; then

        if [ -d "$f/$THEME-dark/xfwm4" ]; then
          found=$(($found+1))
        else
          echo "fail!"
          echo "xfwm4 dark theme not found!"
          echo
          CheckErrors=$(($CheckErrors|$E_THEME_GTK))
          return 1
        fi

      else
        echo "fail!"
        echo "GTK theme doesn't have a light/dark variant!"
        echo
        CheckErrors=$(($CheckErrors|$E_THEME_GTK))
        return 1
      fi
    fi
  done

  if [ $found -ne 2 ]; then
    echo "fail!"
    echo "GTK theme not found!"
    echo
    CheckErrors=$(($CheckErrors|$E_THEME_GTK))
    return 1
  fi

  echo "ok!"

  # Check if icon theme folders with $THEME name exists
  printf "Checking icon theme... "
  found=0
  for f in ${icon_folders[@]}; do

    if [ -d "$f/$THEME" ]; then
      if [ -d "$f/$THEME-dark" ]; then
        found=1
      else
        echo "fail!"
        echo "Icon theme doesn't have a light/dark variant!"
        echo
        CheckErrors=$(($CheckErrors|$E_THEME_ICON))
        return 1
      fi
      break
    fi
  done

  if [ $found -eq 0 ]; then
    echo "fail!"
    echo
    CheckErrors=$(($CheckErrors|$E_THEME_ICON))
    return 1
  else
    echo "ok!"
  fi

  echo

  return 0
}


## SET XFCE THEME
function set_theme {
  mode=$1
  themes_check
  if [ $(($CheckErrors&$E_THEME_GTK)) -ne 0 ]; then
    return 1
  fi

  echo "Apply $mode variant for $THEME theme"

  case $mode in
    dark)
      $echoIt xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME-dark"
      $echoIt xfconf-query -c xfwm4 -p /general/theme -s "$THEME-dark"
      if [ $(($CheckErrors&$E_THEME_ICON)) -eq 0 ]; then
        $echoIt xfconf-query -c xsettings -p /Net/IconThemeName -s "$THEME-dark"
      fi
      ;;

    light|afternoon)
      $echoIt xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME"
      $echoIt xfconf-query -c xfwm4 -p /general/theme -s "$THEME"
      if [ $(($CheckErrors&$E_THEME_ICON)) -eq 0 ]; then
        $echoIt xfconf-query -c xsettings -p /Net/IconThemeName -s "$THEME"
      fi
      ;;

    *)
      help
  esac

  return 0
}


## SET XFCE BACKGROUND
function set_wallpaper {
  mode=$1
  wallpapers_check
  if ( [ $? -ne 0 ] || [ $(($CheckErrors&$E_WALLPAPER)) -ne 0 ] ); then
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
    themes_check
    exit $CheckErrors
    ;;

  *)
    help
esac

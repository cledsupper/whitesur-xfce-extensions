#!/usr/bin/env bash

## ERRORS BITWISE
readonly E_WALLPAPER=1
readonly E_THEME_GTK=2
readonly E_THEME_ICON=4

readonly CHECK_COMMAND=0  # check files and settings before changing anything
readonly CHECK_ONLY=1 # check and quit
readonly CHECK_NONE=2 # run commands without checking files and settings

# LOG COMMANDS INSTEAD OF EXECUTING
readonly DEBUG_MODE=1
echoIt=""
if [ $DEBUG_MODE -eq 1 ]; then
  echoIt="echo"
fi

function help {
  echo "USAGE: $SCRIPT [flags] [options]"
  echo
  echo "OPTIONS"
  echo "    -t \"MyTheme\": theme basename (\"Adwaita-dark\" -> \"Adwaita\")"
  echo "    -m [light|afternoon|dark]: variants for theme AND wallpaper"
  echo "        afternoon is default"
  echo "    -w \"MyWallpaper\" \"/path/to/wallpapers\": wallpaper basename and full path (\"MyWallpaper-light.png\" -> \"MyWallpaper\")"
  echo
  echo "FLAGS"
  echo "    --check-only: check files and settings and return errors"
  echo "    --no-check: run commands without checking anything"
  echo "    --show: print current theme or wallpaper (set nothing)"
  echo
  echo "themeset.sh"
  echo "by cleds.upper"
}

## CHECK IF WALLPAPERS AND XFCONF PATH DO EXIST
function wallpapers_check {
  if [ $CHECK -eq $CHECK_NONE ]; then
    return 0
  fi

  printf "Checking for xfce4-desktop wallpaper property... "
  xfconf-query -c xfce4-desktop -p $THEMESET_PROP_WP 1> /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "fail!"
    echo "xfce4-desktop's wallpaper property not found!"
    echo
    THEMED_ERRORS=$(($THEMED_ERRORS|$E_WALLPAPER))
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
      THEMED_ERRORS=$(($THEMED_ERRORS|$E_WALLPAPER))
      return 1
    fi
    echo "ok!"
  done
  echo

  return 0
}

## CHECK IF THEMES DO EXIST
function themes_check {
  if [ $CHECK -eq $CHECK_NONE ]; then
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
        THEMED_ERRORS=$(($THEMED_ERRORS|$E_THEME_GTK))
        return 1
      fi

      if [ -d "$f/$THEME-dark" ]; then

        if [ -d "$f/$THEME-dark/xfwm4" ]; then
          found=$(($found+1))
        else
          echo "fail!"
          echo "xfwm4 dark theme not found!"
          echo
          THEMED_ERRORS=$(($THEMED_ERRORS|$E_THEME_GTK))
          return 1
        fi

      else
        echo "fail!"
        echo "GTK theme doesn't have a light/dark variant!"
        echo
        THEMED_ERRORS=$(($THEMED_ERRORS|$E_THEME_GTK))
        return 1
      fi
    fi
  done

  if [ $found -ne 2 ]; then
    echo "fail!"
    echo "GTK theme not found!"
    echo
    THEMED_ERRORS=$(($THEMED_ERRORS|$E_THEME_GTK))
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
        THEMED_ERRORS=$(($THEMED_ERRORS|$E_THEME_ICON))
        return 1
      fi
      break
    fi
  done

  if [ $found -eq 0 ]; then
    echo "fail!"
    echo
    THEMED_ERRORS=$(($THEMED_ERRORS|$E_THEME_ICON))
    return 1
  else
    echo "ok!"
  fi

  echo

  return 0
}


## SET XFCE THEME
function set_theme {
  if [ $(($THEMED_ERRORS&$E_THEME_GTK)) -ne 0 ]; then
    return 1
  fi

  echo "Apply $MODE variant for $THEME theme"

  case $MODE in
    dark)
      $echoIt xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME-dark"
      $echoIt xfconf-query -c xfwm4 -p /general/theme -s "$THEME-dark"
      if [ $(($THEMED_ERRORS&$E_THEME_ICON)) -eq 0 ]; then
        $echoIt xfconf-query -c xsettings -p /Net/IconThemeName -s "$THEME-dark"
      fi
      ;;

    light|afternoon)
      $echoIt xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME"
      $echoIt xfconf-query -c xfwm4 -p /general/theme -s "$THEME"
      if [ $(($THEMED_ERRORS&$E_THEME_ICON)) -eq 0 ]; then
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
  if [ $(($THEMED_ERRORS&$E_WALLPAPER)) -ne 0 ]; then
    return 1
  fi

  echo "Set wallpaper to $MODE mode"

  case $MODE in
    dark)
      $echoIt xfconf-query -c xfce4-desktop -p $THEMESET_PROP_WP -s "$WALLPAPER_DARK"
      ;;
    afternoon)
      $echoIt xfconf-query -c xfce4-desktop -p $THEMESET_PROP_WP -s "$WALLPAPER_AFTERNOON"
      ;;
    light)
      $echoIt xfconf-query -c xfce4-desktop -p $THEMESET_PROP_WP -s "$WALLPAPER_LIGHT"
      ;;
    *)
      help
  esac
}

function show_wallpaper {
  xfconf-query -c xfce4-desktop -p $THEMESET_PROP_WP
}

function show_theme {
  gtkName=$(xfconf-query -c xsettings -p /Net/ThemeName)
  gtkBasename=$(echo $gtkName | grep -Eio "^[a-z0-9_]+")
  gtkVariant=$(echo $gtkName | grep -Eo "\-(dark|light)" | grep -Eo "(dark|light)")
  iconName=$(xfconf-query -c xsettings -p /Net/IconThemeName)
  iconBasename=$(echo $iconName | grep -Eio "^[a-z0-9_]+")
  iconVariant=$(echo $iconName | grep -Eo "\-(dark|light)" | grep -Eo "(dark|light)")
  echo "GTK: $gtkBasename ($gtkVariant)"
  echo "Icon: $iconBasename ($iconVariant)"
}


#function initialize {
  SCRIPT=$0
  CHECK=0 # default
  MODE="afternoon"

  # boolean values
  USE_THEME=0
  USE_WALLPAPER=0
  SET_NOTHING=0

  args=("$@")
  narg=0
  skip=0

  # flags first
  for arg in "${args[@]}"; do
    if [ "$arg" = "--no-check" ]; then
      CHECK=$CHECK_NONE
    elif [ "$arg" = "--check-only" ]; then
      CHECK=$CHECK_ONLY
    elif [ "$arg" = "--show" ]; then
      SET_NOTHING=1
    fi
  done

  for arg in "${args[@]}"; do
    if [ $skip -lt 1 ]; then

      if ( [ "$arg" = "--no-check" ]\
        || [ "$arg" = "--check-only" ]\
        || [ "$arg" = "--show" ] ); then
        :
      else
        skip=1
        if [ "$arg" = "-t" ]; then
          USE_THEME=1
          THEME=${args[$narg+1]}
        elif [ "$arg" = "-m" ]; then
          MODE=${args[$narg+1]}
        elif [ "$arg" = "-w" ]; then
          skip=2
          USE_WALLPAPER=1
          WALLPAPER=${args[$narg+1]}
          DIR_WALLPAPER=${args[$narg+2]}
        else
          help
          exit 255
        fi
        if [ $SET_NOTHING -eq 1 ]; then
          skip=0
        fi

        if [ $SET_NOTHING -eq 0 ]; then
          s=$skip
          while [ $s -gt 0 ]; do
            if [ "${args[$narg+$s]}" = "" ]; then
              help
              exit 255
            fi
            s=$(($s-1))
          done
        fi
      fi

    else
      skip=$(($skip-1))
    fi
    narg=$(($narg+1))
  done

  if [ "$THEMED_ERRORS" = "" ]; then
    THEMED_ERRORS=0
  fi

  if [ $USE_WALLPAPER -eq 1 ]; then
    # This may change according to each device
    if [ "$THEMESET_PROP_WP" = "" ]; then
      disProfile=$(xfconf-query -c displays -p /ActiveProfile)
      # disProfile: Default
      disName=$(xfconf-query -c displays -p /$disProfile -l | grep -Eio -m 1 "[a-z]+\-[0-9]+")
      # disName: XYZ-1
      THEMESET_PROP_WP="/backdrop/screen0/monitor$disName/workspace0/last-image"
    fi

    if [ $(($THEMED_ERRORS&$E_WALLPAPER)) -eq 0 ]; then
      if [ -d "$DIR_WALLPAPER" ]; then
        FILENAME_ENDING=$(ls $DIR_WALLPAPER | grep -i -E -o -m 1 "\.[a-z]{3}")
        WALLPAPER_LIGHT="$DIR_WALLPAPER/$WALLPAPER-light$FILENAME_ENDING"
        WALLPAPER_AFTERNOON="$DIR_WALLPAPER/$WALLPAPER$FILENAME_ENDING"
        WALLPAPER_DARK="$DIR_WALLPAPER/$WALLPAPER-dark$FILENAME_ENDING"
      else
        echo "Wallpaper folder not found!"
        THEMED_ERRORS=$(($THEMED_ERRORS|$E_WALLPAPER))
      fi
    fi

    if [ $SET_NOTHING -eq 1 ]; then
      show_wallpaper
    else
      if [ $CHECK -ne $CHECK_NONE ]; then
        wallpapers_check
      fi
      if [ $CHECK -ne $CHECK_ONLY ]; then
        set_wallpaper
      fi
    fi
  fi

  if [ $USE_THEME -eq 1 ]; then
    if [ $SET_NOTHING -eq 1 ]; then
      show_theme
    else
      if [ $CHECK -ne $CHECK_NONE ]; then
        themes_check
      fi
      if [ $CHECK -ne $CHECK_ONLY ]; then
        set_theme
      fi
    fi
  fi
  
  exit $THEMED_ERRORS
# }

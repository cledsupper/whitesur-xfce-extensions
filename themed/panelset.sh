#!/usr/bin/env bash

# THEME DARK
readonly THD=("0.215686" "0.215686" "0.215686" "0.2")
# THEME LIGHT
readonly THL=("1" "1" "1" "0.2")

# LOG COMMANDS INSTEAD OF EXECUTING
readonly DEBUG_MODE=1
echoIt=""
if [ $DEBUG_MODE -eq 1 ]; then
  echoIt="echo"
fi

function set_panel {
  mode=$1
  echo "Set panel to $mode mode"
  case $mode in
    dark)
      $echoIt xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba\
       -t double -t double -t double -t double\
       -s ${THD[0]} -s ${THD[1]} -s ${THD[2]} -s ${THD[3]}
      $echoIt xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -s 1
      ;;

    light|afternoon)
      $echoIt xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba\
       -t double -t double -t double -t double\
       -s ${THL[0]} -s ${THL[1]} -s ${THL[2]} -s ${THL[3]}
      $echoIt xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -s 1
      ;;

    default)
      $echoIt xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -s 0
      ;;

    *)
      echo "USAGE: $0 [default | dark | light | afternoon]"
     ;;
  esac
}

case $1 in
  config)
    ;;

  *)
    set_panel $1
esac

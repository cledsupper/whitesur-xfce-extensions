#!/usr/bin/env bash

if [ -d "metacity-1" ]; then

  echo "Generating icons for WhiteSur theme..."

  mkdir unity

  # Close Button
  cp\
    metacity-1/titlebuttons/titlebutton-close.svg\
    unity/close.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-close-hover.svg\
    unity/close_focused_prelight.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-close-active.svg\
    unity/close_focused_pressed.svg

  cp\
    metacity-1/titlebuttons/titlebutton-backdrop.svg\
    unity/close_unfocused.svg
  
  cd unity
  ln -s close.svg close_focused_normal.svg
  cd ..
  
  # Maximize Button
  cp\
    metacity-1/titlebuttons/titlebutton-maximize.svg\
    unity/maximize.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-maximize-hover.svg\
    unity/maximize_focused_prelight.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-maximize-active.svg\
    unity/maximize_focused_pressed.svg
  
  cd unity
  ln -s close_unfocused.svg maximize_unfocused.svg
  
  # Unmaximize Button
  ln -s maximize.svg unmaximize.svg
  ln -s maximize.svg maximize_focused_normal.svg
  cd ..

  cp\
    metacity-1/titlebuttons/titlebutton-unmaximize-hover.svg\
    unity/unmaximize_focused_prelight.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-unmaximize-active.svg\
    unity/unmaximize_focused_pressed.svg
  
  cd unity
  ln -s close_unfocused.svg unmaximize_unfocused.svg
  ln -s maximize.svg unmaximize_focused_normal.svg
  cd ..
  
  # Minimize Button
  cp\
    metacity-1/titlebuttons/titlebutton-minimize.svg\
    unity/minimize.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-minimize-hover.svg\
    unity/minimize_focused_prelight.svg
  
  cp\
    metacity-1/titlebuttons/titlebutton-minimize-active.svg\
    unity/minimize_focused_pressed.svg
  
  cd unity
  ln -s close_unfocused.svg minimize_unfocused.svg
  ln -s minimize.svg minimize_focused_normal.svg
  cd ..
  
  echo "FINISHED!"
  echo "by cleds.upper"

else
  echo "This script depends on \"metacity-1\" icons"
  exit 1
fi

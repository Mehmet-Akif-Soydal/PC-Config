#!/bin/bash
killall -9 xdg-desktop-portal-hyprland xdg-desktop-portal
nohup /usr/libexec/xdg-desktop-portal-hyprland >/dev/null 2>&1 &
sleep 2
nohup /usr/libexec/xdg-desktop-portal >/dev/null 2>&1 &

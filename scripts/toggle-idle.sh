#!/bin/bash
if pidof hypridle > /dev/null; then
    killall hypridle
    notify-send "☕ Uyku Engelleyici" "Aktif (Ekran Kapanmayacak)" -i dialog-information
else
    hypridle &
    notify-send "💤 Uyku Engelleyici" "Devre Dışı (Ekran Normal Kapanacak)" -i dialog-information
fi

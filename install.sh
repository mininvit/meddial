#!/bin/sh
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
APP="$HOME/.local/share/applications"

chmod +x "$DIR/meddial.py"

mkdir -p "$APP"
sed "s|__DIR__|$DIR|" "$DIR/meddial.desktop" > "$APP/meddial.desktop"
update-desktop-database "$APP" 2>/dev/null || true
xdg-mime default meddial.desktop x-scheme-handler/meddial

if ! id -nG "$USER" | grep -qw dialout; then
    echo "Доступ к модему: выполните  sudo usermod -aG dialout $USER  и перезайдите в систему."
fi

if python3 -c "import serial" 2>/dev/null; then
    echo "pyserial найден."
else
    echo "pyserial не установлен — программа будет работать в прямом режиме, это нормально."
    echo "  (по желанию для более точного определения порта: sudo dnf install python3-pyserial)"
fi

echo "Готово. Проверка набора:  python3 $DIR/meddial.py meddial:1234567"

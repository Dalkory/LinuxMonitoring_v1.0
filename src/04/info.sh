#!/bin/bash

# Функция для вывода цветного текста
function print_colorful() {
    bash color.sh "$@" # $@ - передаст все аргументы командной строки в этот скрипт
}

# Получаем номера цветов для фона и шрифта из аргументов командной строки
name_background_number=$1
name_font_number=$2
value_background_number=$3
value_font_number=$4

# Функция для вывода названия и значения параметра
function print_parameter() {
    local name=$1
    local value=$2
    print_colorful "$name_background_number" "$name_font_number" "$value_background_number" "$value_font_number" "$name" "$value"
}

# Массив параметров
params=(
    'HOSTNAME' "$(hostname)"
)

TIMEZON=$(cat /etc/timezone) 
UTC_TIME=$(date -u +%H)
LOCAL_TIME=$(date +%H)
OFFSET=$(expr $LOCAL_TIME - $UTC_TIME)
if [ $OFFSET -gt 0 ]; then
  SIGN="UTC +"
else
  SIGN="UTC -"  
fi
TIMEZONE="$TIMEZON $SIGN$OFFSET"
params+=('TIMEZONE' "$TIMEZONE")

params+=('USER' "$USER")

OS_long=$(cat /etc/issue)
array=($OS_long)
OS="${array[@]:0:3}"
params+=('OS' "$OS")

params+=('DATE' "$(date +"%d %b %Y %H:%M:%S")")
params+=('UPTIME' "$(uptime -p)")
params+=('UPTIME_SEC' "$(awk '{ print $1 }' /proc/uptime)")
params+=('IP' "$(hostname -I)")
params+=('MASK' "$(ip a | grep inet | grep brd | awk '{ print $4 }')")
params+=('GATEWAY' "$(ip route | grep default | awk '{ print $3 }')")

# Получаем информацию о памяти
ram_total=$(free -t -m | grep Total: | awk '{ print $2 }')
ram_used=$(free -t -m | grep Total: | awk '{ print $3 }')
ram_free=$(free -t -m | grep Total: | awk '{ print $4 }')

# Функция для конвертации МБ в ГБ
function my_convert_gb() {
    bash convert_gb.sh "$1"
}

RAM_TOTAL=$(my_convert_gb "$ram_total")
RAM_USED=$(my_convert_gb "$ram_used")
RAM_FREE=$(my_convert_gb "$ram_free")

params+=('RAM_TOTAL' "$RAM_TOTAL")
params+=('RAM_USED' "$RAM_USED")
params+=('RAM_FREE' "$RAM_FREE")

# Получаем информацию о свободном месте на корневом разделе
space_root=$(df -k | grep ubuntu | awk '{ print $2 }')
space_root_used=$(df -k | grep ubuntu | awk '{ print $3 }')
space_root_free=$(df -k | grep ubuntu | awk '{ print $4 }')

# Функция для конвертации КБ в МБ
function my_convert_mb() {
    bash convert_mb.sh "$1"
}

SPACE_ROOT=$(my_convert_mb "$space_root")
SPACE_ROOT_USED=$(my_convert_mb "$space_root_used")
SPACE_ROOT_FREE=$(my_convert_mb "$space_root_free")

params+=('SPACE_ROOT' "$SPACE_ROOT")
params+=('SPACE_ROOT_USED' "$SPACE_ROOT_USED")
params+=('SPACE_ROOT_FREE' "$SPACE_ROOT_FREE")

# Выводим параметры
for ((i = 0; i < ${#params[@]}; i += 2)); do
    print_parameter "${params[i]}" "${params[i + 1]}"
done
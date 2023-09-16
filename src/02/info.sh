#!/bin/bash

# Функция для вывода названия и значения параметра
function print_parameter() {
    local name=$1
    local value=$2
    echo "$name = $value"
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

# Получить информацию о памяти
ram_total=$(free -t -m | grep Total: | awk '{ print $2 }')
ram_used=$(free -t -m | grep Total: | awk '{ print $3 }')
ram_free=$(free -t -m | grep Total: | awk '{ print $4 }')

# Конвертировать память в GB
function my_convert_gb() {
  bash convert_gb.sh $1    
}

RAM_TOTAL=$(my_convert_gb "$ram_total")
RAM_USED=$(my_convert_gb "$ram_used")
RAM_FREE=$(my_convert_gb "$ram_free")

params+=('RAM_TOTAL' "$RAM_TOTAL")
params+=('RAM_USED' "$RAM_USED")
params+=('RAM_FREE' "$RAM_FREE")

# Получить информацию о дисковом пространстве
space_root=$(df -k | grep ubuntu | awk '{ print $2 }')
space_root_used=$(df -k | grep ubuntu | awk '{ print $3 }')  
space_root_free=$(df -k | grep ubuntu | awk '{ print $4 }')

# Конвертировать дисковое пространство в MB
function my_convert_mb() {
  bash convert_mb.sh $1
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

# '#' - возвращает длину массива params
# '@' - расширяет, чтобы предоставить все элементы массива params
# ${#params[@]} - это выражение, которое возвращает количество элементов в массиве params
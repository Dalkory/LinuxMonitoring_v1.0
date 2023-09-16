#!/bin/bash

# Получаем номера цветов для фона и шрифта названий
name_background_number=$1
name_font_number=$2

# Получаем номера цветов для фона и шрифта значений
value_background_number=$3
value_font_number=$4

# Получаем название параметра
name=$5

# Получаем значение параметра
shift 5
value="$*" # переменная value будет содержать все аргументы командной строки, переданные скрипту или функции

# Определение цветов шрифта и фона в виде ассоциативных массивов
declare -A font_colors=(
    [1]='\e[1;37m' # white
    [2]='\e[1;31m' # red 
    [3]='\e[1;32m' # green
    [4]='\e[1;34m' # blue
    [5]='\e[1;35m' # purple
    [6]='\e[1;30m' # black
)

declare -A background_colors=(
    [1]='\e[1;47m' # white
    [2]='\e[1;41m' # red
    [3]='\e[1;42m' # green
    [4]='\e[1;44m' # blue
    [5]='\e[1;45m' # purple
    [6]='\e[1;40m' # black
)

# Функция для получения цвета фона по номеру
function get_background_color() {
  echo "${background_colors[$1]}"
}

# Функция для получения цвета шрифта по номеру
function get_font_color() {
  echo "${font_colors[$1]}" 
}

# Получаем цвет фона и шрифта для названия
name_background=$(get_background_color $name_background_number)
name_font=$(get_font_color $name_font_number)

# Получаем цвет фона и шрифта для значения
value_background=$(get_background_color $value_background_number)
value_font=$(get_font_color $value_font_number)

# Определение символов управления цветом
reset_color="\e[0m" # это управляющий символ, который сбрасывает все цветовые и стилевые настройки текста
bold="\e[1m"        #  это управляющий символ, который устанавливает жирный (полужирный) стиль текста

# Функции для установки цветов шрифта и фона
function set_colors() {
    background=$1
    font=$2
    echo -e "${background}${font}"
}

function set_name_colors() {
    set_colors $name_background $name_font
}

function set_value_colors() {
    set_colors $value_background $value_font
}

function reset_colors() {
    echo -e "${reset_color}"
}

# Вывод названия и значения с цветом
echo -e "$(set_name_colors)${bold}${name}$(reset_colors) = $(set_value_colors)${bold}${value}$(reset_colors)"
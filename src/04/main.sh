#!/bin/bash

colors_file='colors.conf'
colors_file_defaults='colors_defaults.conf'

# Чтение цветов из файлов colors.conf и colors_defaults.conf
colors=$(awk '{print $1}' $colors_file)
colors_defaults=$(awk '{a = a " " $1} END { print a }' $colors_file_defaults)

colors_array=($colors)
colors_array_defaults=($colors_defaults)

# Поиск цветов и замена на значения по умолчанию, если не найдены
# column1_background
if [[ ${colors_array[0]} =~ 'column1_background=' ]] ; then
    string=${colors_array[0]}
elif [[ ${colors_array[1]} =~ 'column1_background=' ]] ; then
    string=${colors_array[1]}
elif [[ ${colors_array[2]} =~ 'column1_background=' ]] ; then
    string=${colors_array[2]}
elif [[ ${colors_array[3]} =~ 'column1_background=' ]] ; then
    string=${colors_array[3]}
else 
    string=${colors_array_defaults[0]}
    nbc_default='true'
    echo 'column1_background не найден'
fi
name_background_color=${string:19:1}


# column1_font_color
if [[ ${colors_array[0]} =~ 'column1_font_color=' ]] ; then
    string=${colors_array[0]}
elif [[ ${colors_array[1]} =~ 'column1_font_color=' ]] ; then
    string=${colors_array[1]}
elif [[ ${colors_array[2]} =~ 'column1_font_color=' ]] ; then
    string=${colors_array[2]}
elif [[ ${colors_array[3]} =~ 'column1_font_color=' ]] ; then
    string=${colors_array[3]}
else 
    string=${colors_array_defaults[1]}
    nfc_default='true'
fi
name_font_color=${string:19:1}


# column2_background
if [[ ${colors_array[0]} =~ 'column2_background=' ]] ; then
    string=${colors_array[0]}
elif [[ ${colors_array[1]} =~ 'column2_background=' ]] ; then
    string=${colors_array[1]}
elif [[ ${colors_array[2]} =~ 'column2_background=' ]] ; then
    string=${colors_array[2]}
elif [[ ${colors_array[3]} =~ 'column2_background=' ]] ; then
    string=${colors_array[3]}
else 
    string=${colors_array_defaults[2]}
    vbc_default='true'
fi
value_background_color=${string:19:1}


# column2_font_color
if [[ ${colors_array[0]} =~ 'column2_font_color=' ]] ; then
    string=${colors_array[0]}
elif [[ ${colors_array[1]} =~ 'column2_font_color=' ]] ; then
    string=${colors_array[1]}
elif [[ ${colors_array[2]} =~ 'column2_font_color=' ]] ; then
    string=${colors_array[2]}
elif [[ ${colors_array[3]} =~ 'column2_font_color=' ]] ; then
    string=${colors_array[3]}
else 
    string=${colors_array_defaults[3]}
    vfc_default='true'
fi
value_font_color=${string:19:1}


# Проверка, совпадают ли цвета шрифта и фона
if [[ $name_background_color -eq $name_font_color ]] ; then
    echo 'Цвет фона и цвет шрифта для имени совпадают!'
    echo 'Отредактируйте файл '$colors_file' или '$colors_file_defaults', чтобы задать разные цвета!'
    exit 1
fi

if [[ $value_background_color -eq $value_font_color ]] ; then
    echo 'Цвет фона и цвет шрифта для значения совпадают!'
    echo 'Отредактируйте файл '$colors_file' или '$colors_file_defaults', чтобы задать разные цвета!'
    exit 1
fi

# Вывод цветной информации
function get_info()
{
    bash info.sh $1 $2 $3 $4
}

info=$(get_info $name_background_color $name_font_color $value_background_color $value_font_color)
echo "$info"


# Вывод схемы цветов
function get_color_name()
{
    color_number=$1
    if [[ $color_number -eq 1 ]] ; then
        echo 'white'
    elif [[ $color_number -eq 2 ]] ; then
        echo 'red'
    elif [[ $color_number -eq 3 ]] ; then
        echo 'green'
    elif [[ $color_number -eq 4 ]] ; then
        echo 'blue'
    elif [[ $color_number -eq 5 ]] ; then
        echo 'purple'
    elif [[ $color_number -eq 6 ]] ; then
        echo 'black'
    fi
}

echo
echo -n 'Column 1 background = '
if [[ $nbc_default == 'true' ]] ; then
    echo -n 'default '
else
    echo -n $name_background_color' '
fi
echo '('$(get_color_name $name_background_color)')'

echo -n 'Column 1 font color = '
if [[ $nfc_default == 'true' ]] ; then
    echo -n 'default '
else
    echo -n $name_font_color' '
fi
echo '('$(get_color_name $name_font_color)')'

echo -n 'Column 2 background = '
if [[ $vbc_default == 'true' ]] ; then
    echo -n 'default '
else
    echo -n $value_background_color' '
fi
echo '('$(get_color_name $value_background_color)')'

echo -n 'Column 2 font color = '
if [[ $vfc_default == 'true' ]] ; then
    echo -n 'default '
else
    echo -n $value_font_color' '
fi
echo '('$(get_color_name $value_font_color)')'
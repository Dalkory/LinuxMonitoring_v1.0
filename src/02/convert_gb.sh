#!/bin/bash

# Получить входной параметр
input="$1"

# Определить количество символов в строке
len="${#input}"

# ':' - работают так что, первое значение это строка, а первая после ':' указывает начальный индекс подстроки, а значение после второго ':' указывает длину подстроки.

# Отформатировать число
if (( len > 3 )); then
  result="${input:0:$len-3}.${input:$len-3:3} GB"

elif (( len == 3 )); then
  result="0.$input GB"

elif (( len == 2 )); then
  result="0.0$input GB"

elif (( len == 1 )); then
  result="0.00$input GB"
  
else
  result="0.000 GB"
fi

# Вывод
echo "$result"
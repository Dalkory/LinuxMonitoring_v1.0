#!/bin/bash

# Получить информацию
info=$(bash info.sh)

# Вывести информацию 
echo "$info"

# Запросить подтверждение на запись в файл 
echo "Записать информацию в файл? [Y/N]"

# Записать данный ответ
read choice

# Проверить ответ 
if [[ $choice == "y" || $choice == "Y" ]]; then

  # Сгенерировать имя файла
  filename="$(date +%d_%m_%y_%H_%M_%S).status"
  
  # Записать данные в файл
  echo "$info" > "$filename"
  
  # Сообщить о создании файла
  echo "Файл $filename создан"
  
fi
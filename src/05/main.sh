#!/bin/bash

directory=$1

start=`date +%s.%N` # Записываем текущее время в переменную start

#1 Общее количество папок, включая подпапки
number_of_folders=$(find $directory -type d | wc -l) # Подсчитываем количество папок в директории и всех поддиректориях
echo -n 'Total number of folders (including all nested ones) = ' # Выводим сообщение
echo $number_of_folders # Выводим количество папок

#2 Топ 5 папок с наибольшим размером в порядке убывания (путь и размер)
# Найти все папки в указанной директории и вывести путь и размер каждой папки
# Отсортировать результаты по размеру папки в порядке убывания
# Пронумеровать строки
# Форматировать размер папки для удобочитаемости с использованием двоично-дескрипторных приставок
# Взять первые 5 строк
# Отформатировать вывод в виде таблицы с выравниванием по вертикали
top_5_folders=$(find $directory -type d -printf '%p %s\n' | sort -r -n -k2 | nl | numfmt --to=iec --field=3 | awk '{ print $1 " - " $2 ", " $3 }' | head -5 | column -t)
echo 'TOP 5 folders of maximum size size arranged in descending order (path and size):' # Выводим заголовок
echo "$top_5_folders" # Выводим топ 5 папок

#3 Общее количество файлов
total_files=$(find $directory -type f | wc -l) # Подсчитываем количество файлов в директории и всех поддиректориях
echo -n 'Total number of files = ' # Выводим сообщение
echo $total_files # Выводим количество файлов

echo -n 'Number of: '
echo ' '

#4 Количество файлов конфигурации (с расширением .conf), текстовых файлов,
# исполняемых файлов, файлов журналов (с расширением .log), архивов, символических ссылок
conf_files=$(find $directory -type f | grep .conf | wc -l) # Подсчитываем количество файлов конфигурации с расширением .conf
echo -n 'Configuration files (with the .conf extension) = ' # Выводим сообщение
echo $conf_files # Выводим количество файлов конфигурации

text_files=$(find $directory -type f | grep .txt | wc -l) # Подсчитываем количество текстовых файлов с расширением .txt
echo -n 'Text files = ' # Выводим сообщение
echo $text_files # Выводим количество текстовых файлов

executable_files=$(find $directory -type f | grep -e .exe -e .elf | wc -l) # Подсчитываем количество исполняемых файлов с расширением .exe или .elf
echo -n 'Executable files = ' # Выводим сообщение
echo $executable_files # Выводим количество исполняемых файлов

log_files=$(find $directory -type f | grep .log | wc -l) # Подсчитываем количество файлов журналов с расширением .log
echo -n 'Log files (with the extension .log) = ' # Выводим сообщение
echo $log_files # Выводим количество файлов журналов

archive_files=$(find $directory -type f | grep -e .tar.gz -e .tar -e .gz -e .zip -e .lzo -e lz4 | wc -l) # Подсчитываем количество архивных файлов с определенными расширениями
echo -n 'Archive files = ' # Выводим сообщение
echo $archive_files # Выводим количество архивных файлов

symbolic_links=$(find $directory -type l | wc -l) # Подсчитываем количество символических ссылок
echo -n 'Symbolic links = ' # Выводим сообщение
echo $symbolic_links # Выводим количество символических ссылок

#5 Топ 10 файлов с наибольшим размером в порядке убывания (путь, размер и тип)
echo 'Top 10 files of maximum size arranged in descending order (path, size and type):' # Выводим заголовок
# Найти все файлы в указанной директории и вывести путь и размер каждого файла
# Использовать разделитель "." для извлечения расширения файла
# Отсортировать результаты по размеру файла в порядке убывания
# Пронумеровать строки
# Форматировать размер файла для удобочитаемости с использованием двоично-дескрипторных приставок
# Взять первые 10 строк
# Отформатировать вывод в виде таблицы с выравниванием по вертикали
top_10=$(find $directory -type f -printf '%p %s\n' | awk -F '.' '{print $0 " " $NF}' | sort -n -r -k2 | nl | numfmt --to=iec --field=3 | awk '{print $1 " - " $2 ", " $3 ", " $4}' | column -t | head -10)
echo "$top_10" # Output the top 10 files

#6 Топ 10 исполняемых файлов с наибольшим размером в порядке убывания (путь, размер и хэш)
bash search.sh $directory # Вызываем сценарий 6.sh, который должен выводить топ 10 исполняемых файлов с наибольшим размером и хэшем

#7 Время выполнения скрипта
end=`date +%s.%N` # Записываем текущее время в переменную end
execution_time=$(echo "$end-$start" | bc -l | numfmt --format="%0.1f") # Вычисляем время выполнения скрипта
echo 'Script execution time (in seconds) = '$execution_time # Выводим время выполнения скрипта
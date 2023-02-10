#!/bin/sh

#
# Описание:
#	Скрипт, который делает первый запуск nifi контейнера.
#	Решает проблему docker persistance: при перезапуске не теряется flow внутри nifi
#	Например: мне лень каждый раз настраивать подключение к базе, с нуля прописывать flow и тд
# 
#
# Алгоритм:
# 	1. Запускаем nifi контейнер
# 	2. Копируем конфиги nifi в локальную директорию
# 	3. Делаем volume в этой директории



# 1. Запускаем контейнер
docker-compose down
docker-compose up -d 

# 2. Копируем конфиги nifi в локальную директорию
sudo docker cp -a test_nifi_1:/opt/nifi/nifi-current/conf/. ./nifi/conf/

# 3. Делаем volume в этой директории
file='./docker-compose.yaml'
commented='# - ./nifi/conf/:/opt/nifi/nifi-current/conf/'
uncommented='- ./nifi/conf/:/opt/nifi/nifi-current/conf/'
if grep -q "$commented" "$file"; then
	echo "commenting is started"
	sed -i "s|$commented|$uncommented|gi" $file
fi

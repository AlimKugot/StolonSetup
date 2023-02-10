#!/bin/sh

# Скрипт, который делает первый запуск nif контейнера.
# Решает проблему docker persistance: при перезапуске не теряется flow внутри nifi

file='./docker-compose.yaml'
commented='# - ./nifi/conf/:/opt/nifi/nifi-current/conf/'
uncommented='- ./nifi/conf/:/opt/nifi/nifi-current/conf/'

# даём nifi создать свои конфиги
docker-compose down
if grep -q "$uncommented" "$file"; then
	echo "uncommenting is started"
	sed -i "s|$commented|$uncommented|gi" $file
fi
docker-compose up -d 

# копируем конифиги в нашу папку
sudo docker cp -a test_nifi_1:/opt/nifi/nifi-current/conf/. ./nifi/conf/
docker-compose down

# возвращаем в исходное состояние 
if grep -q "$commented" "$file"; then
	echo "commenting is started"
	sed -i "s|$commented|$uncommented|gi" $file
fi

# Пример за базово Laravel приложение с custom image за локална разработка, docker-compose и SSL (HTTPS)

## Предварителна подготовка
1. Изтеглете repository [https://github.com/gganchev/demo-laravel-app](gganchev/demo-laravel-app.git) в папка **code**.\
Това може да направите като изпълните командата ```git clone git@github.com:gganchev/demo-laravel-app.git .``` в директория ./code/.
2. Изпълнете в текущата директория командата ```docker build -t myimage:latest .``` в текущата директория, за да създадете базовият image, който ще се използва като основа на image-a за среда за разработка.
3. Изпълнете в текущата директория командата ```cd ./docker/certificates && ./create_certificate.sh mysite.dev```
4. Добавете генерираният файл **./docker/certificates/output/mysite.dev.chain.pem** към доверените сертификати в браузъра си (Google е ваш приятел. ChatGPT също.)

## Стартиране на средата
1. Изпълнете в текущата директория командата ```docker compose build```
2. Изпълнете в текущата директория командата ```docker compose up -d```

## Допълнителни стъпки при първо стартиране
1. Изпълнете в текущата директория команда ```docker exec -it web-container /bin/bash```, за да влезете в **/bin/bash** на работещият контейнер **web-container**
2. В контекста на контейнера, изпълнете команда ```composer install && npm install && npm run build```, за да инсталирате служебните файлове за Laravel.
3. Излезте от контейнера с клавишната комбинация Ctrl + D или като изпълните командата exit.
4. Извън контейнера, копирайте файл **./docker/application/.env** в директория **./code/**. Можете да направите това като изпълните командата ```cp ./docker/application/.env ./code``` в текущата директория.

## Тествайте дали работи
1. Ако посетите [https://mysite.dev:8080](https://mysite.dev:8080) можете да се уверите че Laravel приложението работи
2. Ако влезете в **/bin/bash** в контейнер **web-container** и изпълните командата `php artisan migrate`, ще може да се уверите, че Laravel приложението е свързано с базата данни.
3. В контекста на **web-container** изпълнете командата ```redis-cli -h cache-container```, за да се уверите, че **web-container** има връзка до работещ Redis в **cache-container**

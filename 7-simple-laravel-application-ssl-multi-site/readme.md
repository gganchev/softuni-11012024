# Пример за базово Laravel приложение с custom image за локална разработка, docker-compose, SSL (HTTPS), persistent база данни и повече от един домейн

## Предварителна подготовка
1. Изтеглете repository [https://github.com/gganchev/demo-laravel-app](gganchev/demo-laravel-app.git) в папка **code**.\
Това може да направите като изпълните командата ```git clone git@github.com:gganchev/demo-laravel-app.git .``` в директория ./code/.
2. Изпълнете в текущата директория командата ```docker build -t myimage:latest .``` в текущата директория, за да създадете базовият image, който ще се използва като основа на image-a за среда за разработка.
3. Изпълнете в текущата директория командата ```cd ./docker/certificates && ./create_certificate.sh mysite.dev```
4. Изпълнете в текущата директория командата ```cd ./docker/certificates && ./create_certificate.sh yoursite.dev``` 
5. Добавете генерираните файлове **./docker/certificates/output/mysite.dev.chain.pem** и **./docker/certificates/output/yoursite.dev.chain.pem** към доверените сертификати в браузъра си (Google е ваш приятел. ChatGPT също.)

## Стартиране на средата
1. Изпълнете в текущата директория командата ```docker compose build```
2. Изпълнете в текущата директория командата ```docker compose up -d```

## Допълнителни стъпки при първо стартиране
1. Изпълнете в текущата директория команда ```docker exec -it web-container /bin/bash```, за да влезете в **/bin/bash** на работещият контейнер **web-container**
2. В контекста на контейнера, изпълнете команда ```composer install && npm install && npm run build```, за да инсталирате служебните файлове за Laravel.
3. Излезте от контейнера с клавишната комбинация Ctrl + D или като изпълните командата exit.
4. Извън контейнера, копирайте файл **./docker/application/.env** в директория **./code/**. Можете да направите това като изпълните командата ```cp ./docker/application/.env ./code``` в текущата директория.

## Тествайте дали работи
1. Ако посетите [https://mysite.dev](https://mysite.dev) можете да се уверите че Laravel приложението работи
2. Ако посетите [https://yoursite.dev](https://yoursite.dev) можете да се уверите че Laravel приложението работи и за втория домейн
3. Ако влезете в **/bin/bash** в контейнер **web-container** и изпълните командата `php artisan migrate`, ще може да се уверите, че Laravel приложението е свързано с базата данни.
4. В контекста на **web-container** изпълнете командата ```redis-cli -h cache-container```, за да се уверите, че **web-container** има връзка до работещ Redis в **cache-container**
5. Тестване, че базата данни запазва състоянието си извън контейнера и не се нулира при рестартиране на контейнерите: 
   1. Излезте от контейнера с клавишната комбинация Ctrl + D или като изпълните командата exit.
   2. Спрете всички контейнери с командата ```docker compose down```
   3. Пуснете ги отново с командата ```docker compose up -d```
   4. Изпълнете в текущата директория команда ```docker exec -it web-container /bin/bash```, за да влезете в **/bin/bash** на работещият контейнер **web-container**
   5. В контекста на контейнера изпълните командата `php artisan migrate`. Ако изведе **"Nothing to migrate."**, ще знаете, че предишната **migrate** команда, която сте изпълнили се е запазила между рестартирането на контейнерите. 
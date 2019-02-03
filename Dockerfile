FROM mediawiki:latest

WORKDIR /var/www/html/extensions
RUN git clone -bREL1_31 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/VisualEditor.git \
    && cd VisualEditor \
    && git submodule update --init

WORKDIR /var/www/html
COPY composer.local.json /var/www/html/composer.local.json
RUN apt-get update \
    && apt-get install -y zip unzip \
    && curl -Ls https://getcomposer.org/composer.phar -o composer.phar \
    && php composer.phar -n update
FROM tunet/php:8.2.9-fpm-alpine3.18

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && apk add --no-cache \
        git \
        bash \
        zsh \
        libxml2-dev \
        libzip-dev \
        libmcrypt-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libxml2-dev \
        icu-dev \
        autoconf \
        rabbitmq-c-dev \
        libxslt-dev \
    && apk add --update \
        linux-headers \
    && pecl update-channels \
    && pecl install \
        redis \
        amqp \
        xdebug-3.2.2 \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install xml \
    && docker-php-ext-install xsl \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable xml \
    && docker-php-ext-enable amqp \
    && pecl clear-cache \
    && rm -rf /tmp/* /var/cache/apk/* \
    && apk del .build-deps

RUN curl -OL https://getcomposer.org/download/2.5.8/composer.phar \
    && mv ./composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer \
    && curl -sS https://get.symfony.com/cli/installer | bash \
    &&  mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

ARG LINUX_USER_ID

RUN addgroup --gid $LINUX_USER_ID docker \
    && adduser --uid $LINUX_USER_ID --ingroup docker --home /home/docker --shell /bin/zsh --disabled-password --gecos "" docker

USER $LINUX_USER_ID

# ARG COMPOSER_GITHUB_TOKEN
# RUN composer config --global github-oauth.github.com $COMPOSER_GITHUB_TOKEN

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/65a1e4edbe678cdac37ad96ca4bc4f6d77e27adf/tools/install.sh -O - | zsh
RUN echo 'export ZSH=/home/docker/.oh-my-zsh' > ~/.zshrc \
    && echo 'ZSH_THEME="simple"' >> ~/.zshrc \
    && echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc \
    && echo 'PROMPT="%{$fg_bold[yellow]%}php:%{$fg_bold[blue]%}%(!.%1~.%~)%{$reset_color%} "' > ~/.oh-my-zsh/themes/simple.zsh-theme

RUN git config --global user.email "you@example.com" \
    && git config --global user.name "Your Name"

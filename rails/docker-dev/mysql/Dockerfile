FROM mysql:8.0.28

ENV TZ=Asia/Tokyo
ENV LC_ALL=ja_JP.UTF-8

RUN rm -f /etc/apt/sources.list.d/mysql.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
#エラーが出るので導入
        ca-certificates \ 
    && curl -fsSL https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | gpg -o /usr/share/keyrings/mysql-archive-keyring.gpg \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        locales \
        python3 \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8

# Setup MySQL
RUN touch /var/log/mysqld.log \
    && chown mysql:adm /var/log/mysqld.log

RUN mkdir /var/mysql \
    && chown mysql:adm /var/mysql \
    && rm -rf /etc/mysql/conf.d

COPY ./my.cnf /etc/mysql/

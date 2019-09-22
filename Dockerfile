FROM ubuntu:18.04

ENV USER=yandex-disk \
    HOME=/yandex-disk \
    DATA=$HOME/data

RUN set -x \
 # Add non-root user.
 && useradd -m -d $HOME $USER \
 && chown -R $USER:$USER $HOME \
 # Install deps.
 && apt-get update \
 && apt-get install -y -qq --no-install-recommends --no-install-suggests wget gpg gpg-agent \
 # Install Yandex.Disk.
 && printf "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | tee -a /etc/apt/sources.list.d/yandex.list > /dev/null \
 && wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -qO- | apt-key add - \
 && apt-get update \
 && apt-get install -y yandex-disk \
 # Cleanup
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER $USER
VOLUME $HOME
WORKDIR $HOME

ENTRYPOINT ["yandex-disk"]
CMD ["start", "--no-daemon", "--dir=$DATA"]

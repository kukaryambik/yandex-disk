FROM ubuntu:18.04

RUN set -x \
 # Install deps.
 && apt-get update \
 && apt-get install -y -qq --no-install-recommends --no-install-suggests wget gpg gpg-agent \
 # Install Yandex.Disk.
 && printf "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | tee -a /etc/apt/sources.list.d/yandex.list > /dev/null \
 && wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -qO- | apt-key add - \
 && apt-get update \
 && apt-get install -y yandex-disk \
 && mkdir -p /yandex-disk/data \
 # Cleanup
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

VOLUME /yandex-disk

ENTRYPOINT ["yandex-disk", "--dir=/yandex-disk/data", "--auth=/yandex-disk/token"]
CMD ["start", "--no-daemon"]

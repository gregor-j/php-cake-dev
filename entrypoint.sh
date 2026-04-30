#!/usr/bin/env sh
set -eu

# set user and group to match the host user, so that files created by PHP-FPM are owned by the host user instead of root.
[ -n "${HOST_UID}" ] || { echo "HOST_UID is not set"; exit 1; }
[ -n "${HOST_GID}" ] || { echo "HOST_GID is not set"; exit 1; }

if [ "${HOST_GID}" != "$(id -g www-data)" ]; then
    groupmod -o -g "${HOST_GID}" www-data
fi
if [ "${HOST_UID}" != "$(id -u www-data)" ]; then
    usermod -o -u "${HOST_UID}" -g "${HOST_GID}" www-data
fi

APP_ROOT="/var/www/html"

# Ensure CakePHP writable paths exist on bind mounts before PHP-FPM starts.
mkdir -p \
  "${APP_ROOT}/logs" \
  "${APP_ROOT}/tmp/cache/models" \
  "${APP_ROOT}/tmp/cache/persistent" \
  "${APP_ROOT}/tmp/sessions" \
  "${APP_ROOT}/tmp/tests"

# www-data UID/GID is mapped at build time to the host user.
chown -R www-data:www-data "${APP_ROOT}/logs" "${APP_ROOT}/tmp"
chmod -R u+rwX,g+rwX "${APP_ROOT}/logs" "${APP_ROOT}/tmp"

exec docker-php-entrypoint "$@"

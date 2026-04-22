#!/bin/sh
set -e

TPL=/var/www/html/application/config/config.php.tpl
OUT=/var/www/html/application/config/config.php

VARS='${BASE_URL} ${PAGE_TITLE} ${DEFAULT_LANGUAGE} ${REALMLIST} ${REALM_NAME}
      ${DB_HOST} ${DB_PORT} ${DB_USER} ${DB_PASSWORD}
      ${CHAR_DB_NAME} ${AUTH_DB_NAME}
      ${CAPTCHA_TYPE} ${CAPTCHA_KEY} ${CAPTCHA_SECRET}
      ${DEBUG_MODE}'

envsubst "$VARS" < "$TPL" > "$OUT"
chown www-data:www-data "$OUT"
chmod 640 "$OUT"

exec "$@"

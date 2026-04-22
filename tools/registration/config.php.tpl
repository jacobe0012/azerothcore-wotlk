<?php
/**
 * Rendered at container start from environment variables.
 * Source: https://github.com/masterking32/WoWSimpleRegistration
 * Only the fields we actively manage are templated; everything else
 * keeps upstream defaults.
 */

$config['baseurl'] = "${BASE_URL}";
$config['page_title'] = "${PAGE_TITLE}";
$config['language'] = "${DEFAULT_LANGUAGE}";
$config['supported_langs'] = [
    'english' => 'English',
    'chinese-simplified' => 'Chinese Simplified',
    'chinese-traditional' => 'Chinese Traditional',
];

$config['debug_mode'] = ${DEBUG_MODE};

$config['realmlist'] = '${REALMLIST}';
$config['patch_location'] = '';
$config['game_version'] = '3.3.5a (12340)';
$config['expansion'] = '2';
$config['server_core'] = 1;
$config['battlenet_support'] = false;
$config['srp6_support'] = true;
$config['srp6_version'] = 2;

$config['disable_top_players'] = false;
$config['disable_online_players'] = false;
$config['disable_changepassword'] = false;
$config['multiple_email_use'] = false;

$config['template'] = 'light';

$config['smtp_host'] = 'smtp.example.com';
$config['smtp_port'] = 587;
$config['smtp_auth'] = true;
$config['smtp_user'] = 'user@example.com';
$config['smtp_pass'] = '';
$config['smtp_secure'] = 'tls';
$config['smtp_mail'] = 'no-reply@example.com';

$config['vote_system'] = false;
$config['vote_sites'] = array();

$config['captcha_type'] = ${CAPTCHA_TYPE};
$config['captcha_key'] = '${CAPTCHA_KEY}';
$config['captcha_secret'] = '${CAPTCHA_SECRET}';
$config['captcha_language'] = 'en';

$config['soap_for_register'] = false;
$config['soap_host'] = '127.0.0.1';
$config['soap_port'] = '7878';
$config['soap_uri'] = 'urn:AC';
$config['soap_style'] = 'SOAP_RPC';
$config['soap_username'] = '';
$config['soap_password'] = '';
$config['soap_ca_command'] = 'account create {USERNAME} {PASSWORD}';

$config['2fa_support'] = false;
$config['soap_2d_command'] = 'account set 2fa {USERNAME} off';
$config['soap_2e_command'] = 'account set 2fa {USERNAME} {SECRET}';

$config['db_auth_host'] = '${DB_HOST}';
$config['db_auth_port'] = '${DB_PORT}';
$config['db_auth_user'] = '${DB_USER}';
$config['db_auth_pass'] = '${DB_PASSWORD}';
$config['db_auth_dbname'] = '${AUTH_DB_NAME}';

$config['realmlists'] = array(
    "1" => array(
        'realmid'   => 1,
        'realmname' => "${REALM_NAME}",
        'db_host'   => "${DB_HOST}",
        'db_port'   => "${DB_PORT}",
        'db_user'   => "${DB_USER}",
        'db_pass'   => '${DB_PASSWORD}',
        'db_name'   => "${CHAR_DB_NAME}",
    ),
);

$config['script_version'] = '2.0.4';

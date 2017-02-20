<?php
/**
 * Создание дампа БД MySQL/MariaDB.
 */

$user = filter_input(INPUT_POST, 'user', FILTER_SANITIZE_STRING);
if (null === $user) {
    header('Bad Request', true, 400);
    die('Username not specified');
}

$password = filter_input(INPUT_POST, 'password', FILTER_SANITIZE_STRING);
if (null === $password) {
    header('Bad Request', true, 400);
    die('Password not specified');
}

$database = filter_input(INPUT_POST, 'db', FILTER_SANITIZE_STRING);
if (null === $database) {
    header('Bad Request', true, 400);
    die('Database name not specified');
}

$host = filter_input(INPUT_POST, 'host', FILTER_SANITIZE_STRING);
if (null === $host) {
    $host = 'localhost';
}

$command = sprintf(
    'mysqldump --user=%s --password=%s --host=%s %s',
    $user,
    $password,
    $host,
    $database
);

passthru($command);

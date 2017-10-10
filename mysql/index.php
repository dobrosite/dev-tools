<?php
/**
 * Создание дампа БД MySQL/MariaDB.
 */

use Ifsnop\Mysqldump\Mysqldump;

require __DIR__.'/../vendor/autoload.php';

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

try {
    $dump = new Mysqldump(
        'mysql:host='.$host.';dbname='.$database,
        $user,
        $password,
        [
            'add-drop-table' => true,
            'compress' => Mysqldump::GZIP,
        ]
    );
    $dump->start();
} catch (\Exception $e) {
    echo 'mysqldump-php error: '.$e->getMessage();
}

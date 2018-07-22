<?php

ini_set('html_errors', 'on');

require __DIR__.'/vendor/autoload.php';
$loader = new \ManaPHP\Loader();

require __DIR__ . '/app/Swoole.php';
$application = new \App\Swoole($loader);

$application->main();
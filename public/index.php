<?php
require dirname(__DIR__) . '/vendor/autoload.php';

$loader = new \ManaPHP\Loader();
require dirname(__DIR__) . '/app/Application.php';
$app = new \App\Application($loader);
$app->main();
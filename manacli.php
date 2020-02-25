#!/usr/bin/env php
<?php

require __DIR__.'/vendor/autoload.php';

$loader = new \ManaPHP\Loader();

$cli = new \ManaPHP\Cli\Application($loader);

$cli->main();
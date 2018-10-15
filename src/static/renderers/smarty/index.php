<?php
/**
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-09
 */

define('BASE_DIR', str_replace('\\', '/', dirname(__DIR__)));
define('APP',  BASE_DIR . "/app");

require_once BASE_DIR . "/vendor/autoload.php";

use \Core\App;

App::init($argv);

$app = new App();

$app->run();
<?php

/**
 * Config class.
 * Gets a configuration value
 * @date 2/4/17
 * @author Michael Domozhirov <michael@domozhirov.ru>
 */

namespace Core;

class Data {
	private static $data = [];

	public function __construct() {}

	public static function getValue(string $name, string $key) : string {
		$value = null;

		if (isset(static::$data[$name][$key])) {
			$value = (string) static::$data[$name][$key];
		}

		return $value;
	}

	public static function getData(string $name) {
		if (empty(static::$data[$name])) {
			$data_file = APP . "/smarty/data/$name.php";

			if (! file_exists($data_file)) {
				throw new \Exception("Configuration file config.php doesn't exist");
			}

			static::$data[$name] = require APP . "/smarty/data/$name.php";
		}

		return static::$data[$name] ?? null;
	}
}
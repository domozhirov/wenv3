<?php
/**
 * Smarty controller
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-04
 */

namespace Core;

use Smarty;

class View extends Smarty {

	/**
	 * @var array
	 */
	public $options = null;

	/**
	 * View constructor.
	 */
	public function __construct() {
		$this->options         = App::getOptions();
		$this->error_reporting = E_ALL & ~E_NOTICE & ~E_WARNING;
		$this->template_dir    = $this->options['config']['projectDir'] . $this->options['dir'];
		$this->compile_dir     = BASE_DIR . '/var/templates_c/';
		$this->plugins_dir[]   = APP . '/smarty/plugins/';
		$this->config_dir      = APP . '/smarty/configs/';
//		$this->compile_check   = false;
//		$this->security        = true;
//		$this->php_handling    = SMARTY_PHP_REMOVE;

		$this->config_load(APP . '/smarty/configs/localization.conf');

		$this->security_settings["MODIFIER_FUNCS"] = [
			"abs",
			"base_phones",
			"trim",
			"round",
			"floor",
			"ceil",
			"unserialize",
			"strip_tags",
			"stripslashes",
			"json_encode",
			"json_decode",
			"htmlspecialchars",
			"htmlspecialchars_decode",
			"nl2br",
			"regex_replace",
			"urlencode",
			"explode",
			"implode",
			"count",
			"md5",
			"sha1",
			"base64_encode",
			"spellcount",
			"sprintf",
			"rand",
		];

		$this->security_settings["IF_FUNCS"] = [
			"strpos",
			"preg_match",
			"isset",
			"count",
			"true",
			"false",
			"is_object",
			"in_array",
			"array_key_exists",
			"is_array",
			"is_numeric",
			"strtotime",
			"strval",
			"empty",
			"array",
		];

		require_once APP . '/smarty/functions.php';

		$this->register_resource('db', [
			'db_template',
			'timestamp',
			'secure',
			'trusted',
		]);

		$this->register_resource('global', [
			'global_template',
			'timestamp',
			'secure',
			'trusted',
		]);

		$data = Data::getData('common');
		$path = dirname($this->options['path']). '/smarty.json';

		if (file_exists($path) && $json = json_decode(file_get_contents($path), true)) {
			$data = array_merge($data, $json);
		}

		foreach ($data as $key => $value) {
			switch ($key) {
				case 'SCRIPT_NAME':
					$this->assign($key, ! empty($this->options['query']) ? $this->options['query'] : '/');
					break;
				case 'DESIGN_DIR':
				case 'IMAGES_DIR':
				case 'FILES_DIR':
					$this->assign($key, $this->options['dir'] . DIR_SEP);
					break;
				default:
					$this->assign($key, $value);
			}
		}

		parent::__construct();
	}
}

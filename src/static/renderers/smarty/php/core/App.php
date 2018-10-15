<?php
/**
 * Class App
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-11
 */

namespace Core;

use Controllers;

class App {

	private const
		CONTROLLER = 0,
		MODE       = 1,
		OBJECT     = 2;

	private const
		DEFAULT_CONTROLLER = 'TextController',
		DEFAULT_ACTION = 'indexAction';

	/**
	 * @var array
	 */
	private static $_options = [];

	/**
	 * @var string
	 */
	private static $_query = null;

	/**
	 * @var Controller
	 */
	private $_controller = null;

	/**
	 * @var string
	 */
	private $_method = self::DEFAULT_ACTION;

	/**
	 * @var array
	 */
	private $_args = [];

	/**
	 * @var \Smarty
	 */
	private static $_renderer = null;

	/**
	 * App constructor.
	 */
	public function __construct() {}

	/**
	 * @return bool
	 */
	public function run() {
		$this->_splitUrl();

		if (! self::isControllerValid($this->_controller)) {
			return $this->invoke($this->_controller, $this->_method, $this->_args);
		}

		if (! empty($this->_controller)) {
			$controllerName = $this->_controller;

			if (! self::isMethodValid($controllerName, $this->_method)) {
				return false;
			}

			if (! empty($this->_method)) {
				if (! self::areArgsValid($controllerName, $this->_method, $this->_args)) {
					return false;
				}
				// finally instantiate the controller object, and call it's action method.
				return $this->invoke($controllerName, $this->_method, $this->_args);
			} else {
				$this->_method = static::DEFAULT_ACTION;

				if (! method_exists($controllerName, $this->_method)){
					return false;
				}

				return $this->invoke($controllerName, $this->_method, $this->_args);
			}
		} else {
			// if no controller defined,
			// then send to login controller, and it should take care of the request
			// either redirect to login page, or dashboard.
			$this->_method = static::DEFAULT_ACTION;
			return $this->invoke(static::DEFAULT_CONTROLLER, $this->_method, $this->_args);
		}
	}

	/**
	 * @return array
	 */
	public static function getOptions() : array {
		return static::$_options;
	}

	/**
	 * @return bool
	 */
	private function _splitUrl() : bool {
		$url = static::$_query;

		if (! empty($url)) {
			$url = explode('/', filter_var(trim($url, '/'), FILTER_SANITIZE_URL));

			$this->_controller = ! empty($url[0]) ? ucwords($url[0]) . 'Controller' : null;

			if (! empty($url[1])) {
				$this->_method = $url[1] . 'Action';
			}

			unset($url[0], $url[1]);

			$this->_args = ! empty($url) ? array_values($url) : [];
		}

		return true;
	}

	/**
	 * @param array $argv
	 * @return bool
	 */
	public static function init(array &$argv) : bool {
		if (! self::$_options = json_decode($argv[1], true)) {
			die('Config not found');
		}

		$_GET = self::$_options['_GET'];
		$_POST = self::$_options['_POST'];
		$_COOKIE = self::$_options['_COOKIE'];

		static::$_query = self::$_options['query'];

		return true;
	}

	/**
	 * @param $controller
	 * @return bool
	 */
	private static function isControllerValid($controller) {
		if (! empty($controller)) {
			$test1 = preg_match('/\A[a-z]+\z/i', $controller);
			$test2 = file_exists(APP . '/controllers/' . $controller . '.php');
			if (
				! preg_match('/\A[a-z]+\z/i', $controller) ||
				! file_exists(APP . '/controllers/' . $controller . '.php')
			) {
				return false;
			} else {
				return true;
			}
		} else {
			return true;
		}
	}

	/**
	 * @param $controller
	 * @param string $action
	 * @param array $args
	 * @return bool
	 */
	private function invoke($controller, $action, $args) : bool {
		$controller = "Controllers\\$controller";

		$this->_controller = new $controller();
		$result = $this->_controller->startupProcess();
		static::$_renderer = $this->_controller->getView();

		if (! empty($args)) {
			call_user_func_array([$this->_controller, $action], $args);
		} else{
			$this->_controller->{$action}();
		}

		return true;
	}

	/**
	 * @param $controller
	 * @param $method
	 * @param $args
	 * @return bool
	 */
	private function areArgsValid($controller, $method, $args){
		$controller = "Controllers\\$controller";

		$reflection = new \ReflectionMethod($controller, $method);
		$_args = $reflection->getNumberOfParameters();

		if ($_args !== count($args)) {
			return false;
		}

		foreach($args as $arg) {
			if (! preg_match('/\A[a-z0-9]+\z/i', $arg)) {
				return false;
			}
		}

		return true;
	}

	/**
	 * @param $controller
	 * @param $method
	 * @return bool
	 */
	private function isMethodValid($controller, $method){
		if (! empty($method)) {
			$controller = "Controllers\\$controller";

			if (
				! preg_match('/\A[a-z]+\z/i', $method) ||
				! method_exists($controller, $method)  ||
				strtolower($method) === "index"
			) {
				return false;
			} else {
				return true;
			}
		} else {
			return true;
		}
	}

	/**
	 * @return \Smarty
	 */
	public static function getRenderer() {
		return static::$_renderer;
	}
}

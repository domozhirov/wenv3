<?php
/**
 * Class Controller
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-16
 */

namespace Core;

class Controller {

	private const
		NOT_BY_KEY = false;

	/**
	 * @var array
	 */
	protected $_data = [];

	/**
	 * @var View
	 */
	protected $_view = null;

	/**
	 * Controller constructor.
	 */
	public function __construct() {
		$this->_view = new View();
	}

	/**
	 * @return bool
	 */
	public function indexAction() : bool {
		return true;
	}

	/**
	 * @return bool
	 */
	public function startupProcess() : bool {
		$this->setData($this->_data);

		return true;
	}

	protected function setData($data, $key = self::NOT_BY_KEY) {

		foreach ($data as $item) {
			$data = $this->getData($item);

			if ($key) {
				$data = $data[$key] ?? [];
			}

			foreach ($data as $key => $value) {
				$this->_view->assign($key, $value);
			}
		}
	}

	protected function getData($file) {
		$path = APP . '/smarty/data/' . $file . '.php';

		if (file_exists($path)) {
			return require $path;
		} else {
			return [];
		}
	}

	/**
	 * @return View
	 */
	public function getView() {
		return $this->_view;
	}
}
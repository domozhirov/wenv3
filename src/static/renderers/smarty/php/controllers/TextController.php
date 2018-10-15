<?php

/**
 * Class TextController
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-16
 */

namespace Controllers;

use Core\Controller;

class TextController extends Controller {

	/**
	 * @var array
	 */
	protected $_data = [
		'text'
	];

	/**
	 * @return bool
	 */
	public function indexAction() : bool {
		$this->_view->display('global:page.article.tpl');

		return true;
	}
}
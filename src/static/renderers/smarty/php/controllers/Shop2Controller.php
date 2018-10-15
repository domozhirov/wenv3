<?php

/**
 * Class TextController
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-16
 */

namespace Controllers;

use Core\Controller;

class Shop2Controller extends Controller {

	/**
	 * @var array
	 */
	protected $_data = [
		'shop2.main'
	];

	/**
	 * @return bool
	 */
	public function indexAction() : bool {
		$this->_view->assign('mode', 'main');
		$this->_view->display('global:shop2.v2.tpl');

		return true;
	}

	/**
	 * @return bool
	 */
	public function folderAction() : bool {
		$this->setData(['shop2.folder']);

		$this->_view->assign('mode', 'folder');

		$this->_view->_tpl_vars['shop2']['products'] = $this->getData('shop2.products');

		if (isset($_GET['view'])) {
			$this->_view->_tpl_vars['shop2']['view'] = $_GET['view'];
		}

		$this->_view->display('global:shop2.v2.tpl');

		return true;
	}

	/**
	 * @param $product_id
	 * @return bool
	 */
	public function productAction($product_id) : bool {
		$this->setData(['shop2.product'], $product_id);

		$this->_view->assign('mode', 'product');
		$this->_view->display('global:shop2.v2.tpl');

		return true;
	}

	/**
	 * @return bool
	 */
	public function cartAction() : bool {
		$this->setData(['shop2.cart']);

		$this->_view->assign('mode', 'cart');
		$this->_view->display('global:shop2.v2.tpl');

		return true;
	}
}
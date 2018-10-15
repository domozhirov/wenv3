<?php
/**
 * Class Object
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-21
 */

namespace Core;

class Obj {
	public static function __set_state($an_array) {
		$obj = new Obj();

		foreach ($an_array as $key => $value) {
			$obj->{$key} = $value;
		}

		return $obj;
	}
}
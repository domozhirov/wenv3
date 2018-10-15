<?php

function smarty_function_assign_hash ($params, &$smarty) {

	if (!isset($params['var']) || !isset($params['value'])) {
		return;
	}

	$keys = explode('.',$params['var']);
	if (count($keys) < 2) {
		return;
	}

	$key = $keys[0];
	if (!isset($smarty->_tpl_vars[$key]) || !is_array($smarty->_tpl_vars[$key])) {
		return;
	}
	$var = &$smarty->_tpl_vars[$key];
	$len = count($keys) - 1;
	for ($i = 1; $i < $len; $i++) {
		$key = $keys[$i];
		if (!isset($var[$key]) || !is_array($var[$key])) {
			$var[$key] = [];
		}
		$var = &$var[$key];
	}
	$key = $keys[$len];
	$var[$key] = $params['value'];
}
<?php

/**
 * @param string $code
 * @param array $values
 *
 * @return mixed
 */
function smarty_modifier_l($code, ...$values) {
	$smarty = \Core\App::getRenderer();

	if (strlen($code) > 64) {
		return $code;
	}
	$upcode = mb_strtoupper($code);
	if (isset($smarty->_config[0]['vars'][$upcode])) {
		$txt = $smarty->_config[0]['vars'][$upcode];
		if ($values) {
			$txt = vsprintf($txt, $values);
		}
	} else {
		$txt = $code;
		if ($values) {
			$txt .= json_encode($values, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
		}
	}

	return $txt;
}
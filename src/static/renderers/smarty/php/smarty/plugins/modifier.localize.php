<?php

/**
 * @param $string
 * @param $smarty
 * @return mixed|string
 */
function smarty_modifier_localize($string, &$smarty) {
	if (! $string) {
		return '';
	}

	if ((isset($_REQUEST['lang_id']) && $_REQUEST['lang_id'] == -1)) {
		// Leave as is. See #15251.
		return $string;
	}

	if (! $smarty) {
		$smarty = \Core\App::getRenderer();
	}

	if (! empty($string) && is_string($string)) {
		if (preg_match_all('/#([A-Z_0-9]{2,100})#/', $string, $matches, PREG_SET_ORDER)) {
			foreach ($matches as $m) {
				$code = $m[1];
				if (isset($smarty->_config[0]['vars'][$code])) {
					$string = str_replace("#$code#", $smarty->_config[0]['vars'][$code], $string);
				}
			}

			return str_replace('~~~', '#', $string);
		}
	}

	return $string;
}

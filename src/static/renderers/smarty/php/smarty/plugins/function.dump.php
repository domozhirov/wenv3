<?php

function smarty_function_dump ($params, &$smarty) {

    $key = false;
    $hidden = false;
    $res = "";

	if (isset($params['var'])) $key = $params['var'];
	if (isset($params['hidden'])) $hidden = $params['hidden'];

	if ($hidden) $res.= "<!--\n";

	if (isset($params['var'])) {

		$res .= "<br>====================================<br>\n";
		$res .= "start DUMP for alias: <b>$key</b><br>\n";
		$res .= "====================================<br>\n";

		if (!isset($smarty->_tpl_vars[$key])) {

			$res .= "<b>$key</b> - empty\n";

		} else  {

			$res .= "<pre>".str_replace(' =&gt; ',' => ',htmlspecialchars(var_export($smarty->_tpl_vars[$key],true)))."</pre>\n";

		}

	} elseif (isset($params['value'])) {
		$res .= "<br>====================================<br>\n";
		$res .= "start <b>VARIABLE DUMP</b> <br>\n";
		$res .= "====================================<br>\n";

		$value = $params['value'];

		if (is_object($value) && method_exists($value, '__debuginfo')) {
			// Trigger __debuginfo handler. Note, var_export() does not trigger __debuginfo.
			ob_start();
			if (function_exists('xdebug_var_dump')) {
				ini_set('xdebug.overload_var_dump', 0);
			}
			var_dump($value);
			$value = ob_get_clean();
		} else {
			$value = var_export($value, true);
		}

		$res .= "<pre>".str_replace(' =&gt; ',' => ',htmlspecialchars($value))."</pre>\n";

	} else {

		$res .= "<br>====================================<br>\n";
		$res .= "start <b>FULL DUMP</b> <br>\n";
		$res .= "====================================<br>\n";

		$res .= "<pre>".str_replace(' =&gt; ',' => ',htmlspecialchars(var_export($smarty->_tpl_vars,true)))."</pre>\n";

	}

	$res .= "<br>====================================<br>\n";
	$res .= "end DUMP";
	$res .= "<br>====================================<br>\n";

	if ($hidden) $res.= "-->\n";

	return $res;

}

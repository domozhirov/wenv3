<?php

function smarty_function_get_seo_url ($params, /** @noinspection PhpUnusedParameterInspection */ &$smarty) {
	$file = $smarty->options['file'];
	$prefix = $params['uri_prefix'];
	$mode = $params['mode'];
	$alias = $params['alias'];

	$url = "$file" . "$prefix/$mode/$alias";

	return $url;
}
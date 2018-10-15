<?php

function smarty_function_s3_img ($params, &$smarty) {
	return $smarty->options['file'] . "/image/get/" . $params['width'] . 'x' . $params['height'];
}

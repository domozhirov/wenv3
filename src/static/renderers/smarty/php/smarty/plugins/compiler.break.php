<?php
/**
 * @author Aco (Ivan Shalganov) <this@code-master.ru>
 * @version 1.0 (20.01.2010)
 * @copyright Copyright (c) 2010, MegaGroup (http://www.megagroup.ru)
 */

/**
 * @param $contents
 * @param $smarty
 * @return string
 */
function smarty_compiler_break(/** @noinspection PhpUnusedParameterInspection */ $contents, &$smarty) {
	return 'break;';
}
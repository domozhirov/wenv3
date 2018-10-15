<?php
/**
 * @author: Mikhail Domozhirov <michael@domozhirov.ru>
 * @date: 2017-08-16
 */

function db_template($tpl_name, &$tpl_source, &$smarty) {
	$file       = $smarty->options['config']['projectDir'] . $smarty->options['dir'] . DIR_SEP . $tpl_name;
	$tpl_source = file_get_contents($file);

	if ($tpl_source === false) {
		$tpl_source = "Шаблон db:$tpl_name не найден";
	}

	return true;
}

function global_template($tpl_name, &$tpl_source, &$smarty) {
	$file       = $smarty->options['config']['projectDir'] . $smarty->options['dir'] . DIR_SEP . $tpl_name;
	$tpl_source = file_get_contents($file);

	if ($tpl_source === false) {
		$tpl_source = file_get_contents(APP . '/view/' . $tpl_name);
	}

	if ($tpl_source === false) {
		$tpl_source = "Шаблон global:$tpl_name не найден";
	}
	return true;
}

function timestamp($tpl_name, &$tpl_timestamp, &$smarty) {
	$tpl_timestamp = time();
	return true;
}

function secure($tpl_name, &$smarty) {
	return true;
}

function trusted($tpl_name, &$smarty) {
}
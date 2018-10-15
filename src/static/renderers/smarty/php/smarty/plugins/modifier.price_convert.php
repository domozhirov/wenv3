<?php

/**
 * @param float $price
 * @param int $currency_id = NULL
 * @param bool $format = TRUE
 * @param bool $for_cms
 * @return float
 * @throws Exception
 */
function smarty_modifier_price_convert($price, $currency_id = NULL, $format = TRUE, $for_cms = false) {
	return $price;
}
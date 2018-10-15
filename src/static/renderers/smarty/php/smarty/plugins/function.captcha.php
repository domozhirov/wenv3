<?php

function smarty_function_captcha($params, /** @noinspection PhpUnusedParameterInspection */&$smarty) {
	    return '
			<div data-captcha="recaptcha"
				 data-name="{$name}"
				 data-msize="{$mcaptcha_length}"
				 data-sitekey="{$recaptcha_key}"
				 data-lang="{$recaptcha_lang}"
				 data-rsize="{$recaptcha_size}"
				 data-type="{$recaptcha_type}"
				 data-theme="{$recaptcha_theme}">Loading ...</div>
			';
}

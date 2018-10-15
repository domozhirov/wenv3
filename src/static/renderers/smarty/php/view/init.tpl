{if $site.settings.sef_url}{strip}
	{assign var=targetUrl value=$smarty.server.SCRIPT_URL|regex_replace:'#/(p(/[0-9]+)?)?/?$#':''}
	{if $smarty.server.SCRIPT_URL!=$smarty.server.REQUEST_URI&&!$canonical_pages}
		<link rel="canonical" href="{$smarty.server.SCRIPT_URL}"/>
	{elseif ($targetUrl!=$smarty.server.SCRIPT_URL||$smarty.server.SCRIPT_URL!=$smarty.server.REQUEST_URI)&&$canonical_pages&&$targetUrl!=''}
		<link rel="canonical" href="{$targetUrl}"/>
	{/if}
{/strip}
{/if}

<link rel="stylesheet" href="/g/css/styles_articles_tpl.css">
{$common_js}
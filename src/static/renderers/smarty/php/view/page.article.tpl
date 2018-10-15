{assign var=h1 value=$page.h1|default:$text.title}

{include file="db:header.tpl"}

{*s3_require basestyle="article" ext="css" ver="1.0.0"}
{s3_require basestyle="article" ext="js" ver="1.0.0"*}

{$text.body}

{*include file="global:block.g-submenu.tpl"*}

{include file="db:bottom.tpl"}
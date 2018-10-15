{capture assign="shop_content"}

	{if $mode == 'product'}

		{if $site.settings.seo_fields}

			{if $page.seo_title}
				{assign_hash var=page.title value="`$page.seo_title`"}
			{else}
				{assign_hash var=page.title value="`$product.name`"}
			{/if}

			{if $page.seo_keywords}
				{assign_hash var=page.keywords value="`$page.seo_keywords`"}
			{else}
				{assign_hash var=page.keywords value="`$product.name`"}
			{/if}

			{if $page.seo_description}
				{assign_hash var=page.description value="`$page.seo_description`"}
			{else}
				{assign_hash var=page.description value="`$product.name`"}
			{/if}

		{else}

			{assign_hash var=page.title value="`$product.name`"}
			{assign_hash var=page.keywords value="`$product.name`"}
			{assign_hash var=page.description value="`$product.name`"}

		{/if}

		{assign var="h1" value=$page.seo_h1|default:$product.name}
		{include file="global:shop2.v2-product.tpl"}
		<p><a href="javascript:shop2.back()" class="shop2-btn shop2-btn-back">{#SITE_BACK#}</a></p>

	{elseif $mode == 'folder'}

		{if isset($smarty.get.p)}
			{assign var="pn" value="PAGE_TITLE_PAGES"|l|cat:$p+1}
		{/if}

		{if $site.settings.seo_fields}

			{if $page.seo_title}
				{assign_hash var=page.title value="`$page.seo_title` `$pn`"}
			{else}
				{assign_hash var=page.title value="`$folder.folder_name` `$pn`"}
			{/if}

			{if $page.seo_keywords}
				{assign_hash var=page.keywords value="`$page.seo_keywords` `$pn`"}
			{else}
				{assign_hash var=page.keywords value="`$folder.folder_name` `$pn`"}
			{/if}

			{if $page.seo_description}
				{assign_hash var=page.description value="`$page.seo_description` `$pn`"}
			{else}
				{assign_hash var=page.description value="`$folder.folder_name` `$pn`"}
			{/if}

		{else}

			{assign_hash var=page.title value="`$folder.folder_name` `$pn`"}
			{assign_hash var=page.keywords value="`$folder.folder_name` `$pn`"}
			{assign_hash var=page.description value="`$folder.folder_name` `$pn`"}

		{/if}

		{assign var="h1" value=$page.seo_h1|default:$folder.folder_name}

		{if $smarty.get.products_only == 1}

			{include file="global:shop2.v2-product-list.tpl"}
			{include file="global:shop2.v2-pagelist.tpl"}

		{else}

			{if !isset($smarty.get.p) && $folder.folder_desc}
				{$folder.folder_desc}
			{/if}

			{include file="global:shop2.v2-filter.tpl"}
			{include file="global:shop2.v2-product-list.tpl"}
			{include file="global:shop2.v2-pagelist.tpl"}

			{if !isset($smarty.get.p) && $folder.folder_desc2}
				{$folder.folder_desc2}
			{/if}

		{/if}

	{elseif $mode == 'vendor'}

		{if isset($smarty.get.p)}
			{assign var="pn" value="PAGE_TITLE_PAGES"|l|cat:$p+1}
		{/if}

		{if $site.settings.seo_fields}

			{if $page.seo_title}
				{assign_hash var=page.title value="`$page.seo_title` `$pn`"}
			{else}
				{assign_hash var=page.title value="`$vendor.name` `$pn`"}
			{/if}

			{if $page.seo_keywords}
				{assign_hash var=page.keywords value="`$page.seo_keywords` `$pn`"}
			{else}
				{assign_hash var=page.keywords value="`$vendor.name` `$pn`"}
			{/if}

			{if $page.seo_description}
				{assign_hash var=page.description value="`$page.seo_description` `$pn`"}
			{else}
				{assign_hash var=page.description value="`$vendor.name` `$pn`"}
			{/if}

		{else}

			{assign_hash var=page.title value="`$vendor.name` `$pn`"}
			{assign_hash var=page.keywords value="`$vendor.name` `$pn`"}
			{assign_hash var=page.description value="`$vendor.name` `$pn`"}

		{/if}

		{assign var="h1" value=$page.seo_h1|default:$vendor.name}

		{if $smarty.get.product_only == 1}

			{include file="global:shop2.v2-product-list.tpl"}
			{include file="global:shop2.v2-pagelist.tpl"}

		{else}

			{if !isset($smarty.get.p) && $vendor.body}
				{$vendor.body}
			{/if}

			{if $vendor.folders|@count && !$shop2.my.hide_folders_in_vendor}
				<p class="shop2-vendor-folders-header"><b>{#SHOP2_CATEGORIES_PRODUCTS#} &quot;{$vendor.name}&quot;:</b></p>
				<ul class="shop2-vendor-folders">
					{foreach from=$vendor.folders item=_vendor}
						<li><a href="{get_seo_url uri_prefix=$_vendor.page_url mode="folder" alias=$_vendor.alias}?s[vendor_id][]={$vendor.vendor_id}">{$_vendor.folder_name}</a></li>
					{/foreach}
				</ul>
			{/if}

			{include file="global:shop2.v2-filter.tpl"}
			{include file="global:shop2.v2-product-list.tpl"}
			{include file="global:shop2.v2-pagelist.tpl"}

		{/if}

	{elseif $mode=='vendors'}

		{assign var="h1" value="SHOP2_VENDORS2"|l}
		{include file="global:shop2.v2-vendors.tpl"}
		{include file="global:shop2.v2-pagelist.tpl"}

	{elseif $mode == 'cart'}

		{assign var="h1" value="SHOP2_CART"|l}
		{include file="global:shop2.v2-cart.tpl"}
		{*<p><a href="javascript:shop2.back()" class="shop2-btn shop2-btn-back">{#SITE_BACK#}</a></p>*}

	{elseif $mode == 'main'}

		{if $page.h1}
			{assign var="h1" value=$page.h1}
		{/if}
		{include file="global:shop2.v2-main.tpl"}

	{elseif $mode == 'search'}

		{assign var="h1" value="SHOP2_SEARCH"|l}

		{if $smarty.get.products_only == 1}

			{include file="global:shop2.v2-product-list.tpl"}
			{include file="global:shop2.v2-pagelist.tpl" not_seo=1}

		{else}

			{include file="global:shop2.v2-filter.tpl"}
			{include file="global:shop2.v2-product-list.tpl"}
			{include file="global:shop2.v2-pagelist.tpl" not_seo=1}

		{/if}

	{elseif $mode == 'order'}

		{if $step == 'delivery'}

			{assign var="h1" value="SHOP2_DELIVERY2"|l}
			{include file="global:shop2.v2-order-errors.tpl"}
			{include file="global:shop2.v2-order-delivery.tpl"}
			<p><a href="{$shop2.uri}?mode=cart" class="shop2-btn shop2-btn-back">{#SITE_BACK#}</a></p>

		{elseif $step == 'order'}

			{assign var="h1" value="SHOP2_RESERVATION"|l}
			{include file="global:shop2.v2-order-errors.tpl"}
			{include file="global:shop2.v2-order-order.tpl"}
			<p><a href="{if !empty($pre_order.delivery)}{$shop2.uri}?mode=order&amp;step=delivery&amp;action=edit{else}{$shop2.uri}?mode=cart{/if}" class="shop2-btn shop2-btn-back">{#SITE_BACK#}</a></p>


		{elseif $step == 'payment'}

			{assign var="h1" value="SHOP2_ORDER_THANK"|l}
			{include file="global:shop2.v2-order-payment.tpl"}

		{elseif $step == 'payments'}

			{assign var="h1" value="SHOP2_PAYMENTS"|l}
			{include file="global:shop2.v2-order-errors.tpl"}
			{include file="global:shop2.v2-order-payments.tpl"}
			<p><a href="{$shop2.uri}?mode={if $shop2.json.order_in_one_page}cart{else}order&amp;step=order&amp;action=edit{/if}" class="shop2-btn shop2-btn-back">{#SITE_BACK#}</a></p>

		{/if}

	{elseif $mode == 'ps_redirect'}

		{assign var="h1" value="SHOP2_PAYMENT_ORDER"|l}
		{include file="global:shop2-ps-redirect.tpl"}

	{elseif $mode == 'orders'}

		{if $order}
			{assign var="h1" value="SHOP2_YOUR_ORDER"|l}
		{else}
			{assign var="h1" value="SHOP2_YOUR_ORDERS"|l}
		{/if}

		{include file="global:shop2.v2-orders.tpl"}
		{include file="global:shop2.v2-pagelist.tpl" not_seo=1}

	{elseif $mode == 'tag'}

		{assign var="h1" value=$tag}
		{assign_hash var=page.title value="`$tag`"}
		{assign_hash var=page.keywords value="SHOP2_PRODUCTS_LOWERCASE"|l|cat:" `$tag`"}
		{assign_hash var=page.description value="SHOP2_PRODUCTS_LIST"|l|cat:" `$tag`"}

		{include file="global:shop2.v2-product-list.tpl"}
		{include file="global:shop2.v2-pagelist.tpl" not_seo=1}

	{elseif $mode == 'compare'}

		{assign var="h1" value="Сравнение"}
		{include file="global:shop2.v2-compare.tpl"}

	{/if}

{/capture}

{if $smarty.get.products_only==1 || $mode == 'compare'}

	{$shop_content}

{else}
	{include file="db:header.tpl" h1=$h1}

	<div class="shop2-cookies-disabled shop2-warning hide"></div>
	{if $shop2.fallback_mode}
		<div class="shop2-warning">
			<p>{#SHOP2_FALLBACK_MODE#}</p>
		</div>
	{/if}

	{$shop_content}

	{include file="global:shop2.v2-panel.tpl"}

	{include file="db:bottom.tpl"}

{/if}
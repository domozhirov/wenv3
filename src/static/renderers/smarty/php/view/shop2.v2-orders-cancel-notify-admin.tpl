{#SHOP2_HELLO#}<br>
{#SHOP2_ORDER_CANCELLING_WELCOME_TEXT#|sprintf:$url}
<br><br>
{if $order}
		{assign var="currency_shortname" value=$order.currency.shortname}

{capture assign="shop_user_info"}{strip}
	{assign var="data" value=$fields|default:$order_fields}
	{foreach from=$data item=e key=k}
		{assign var="uv_field" value=$order.data.order.$k}
		{if $uv_field}
			{if isset($e.name)}
				{$e.name|htmlspecialchars}
			{else}
				{$e|htmlspecialchars}:&nbsp;
			{/if}
			{if is_array($uv_field)}
				{', '|implode:$uv_field|htmlspecialchars}
			{else}
				{$uv_field|htmlspecialchars}&nbsp; 
				<br>
			{/if}
		{/if}
	{/foreach}
{/strip}{/capture}


{if $shop_user_info}
	{#SHOP2_PERSONAL_DATA#} <br>
	{$shop_user_info}
{/if}

{*Сведения о доставке *}
<br>
{if $order.data.delivery.name && $order_form_settings.delivery_info}
	{#SHOP2_DELIVERY_DETAILS#} <br>
		{#SHOP2_DELIVERY2#}:
		{$order.data.delivery.name|htmlspecialchars}

	{if $payments}
		{assign var="pmnt" value=$payments[$order.data.payment.payment_id]}
	{else}
		{assign var="pmnt" value=$payment}
	{/if}

	{if $order.data.delivery.cost}
			{#SHOP2_DELIVERY_COST#}:
				{$order.data.delivery.cost|price_convert} {$currency_shortname}

				{if $order.data.delivery.edost && $order.data.delivery.pricecash && $order.data.delivery.overcash && in_array($pmnt.code, array('cash', 'self', 'on_delivery'))}
					({#SHOP2_DELIVERY_COST#}: {$order.data.delivery.pricecash-$order.data.delivery.overcash|price_convert} {$currency_shortname}
					+ {#SHOP2_CASH_ON_DELIVERY_EXTRA_CHARGE#} {$order.data.delivery.overcash|price_convert} {$currency_shortname})
					<br>
				{/if}
				
	{elseif $order.data.delivery.delivery_info}
			{#SHOP2_DELIVERY_COST#}:
			{$order.data.delivery.delivery_info}
	{else}
		<br>
			{#SHOP2_DELIVERY_COST#}:
			{#SHOP2_FREE#}
	{/if}

	{if $order.data.delivery.edost && $pmnt.code == 'on_delivery' && $order.data.delivery.transfer > 0}
		<br>
			{#SHOP2_EXTRA_CHARGE_FOR_PAYMENT_TRANSACTION#}:
			{$order.data.delivery.transfer|price_convert} {$currency_shortname} ({#SHOP2_ORDER_DELIVERY_TRANSFER_NOTE#})
	{/if}

	{foreach from=$order.data.delivery.settings item=e key=k}
		{if $e}
			<br>
				{$k|htmlspecialchars}:
				{$e|htmlspecialchars}
		{/if}
	{/foreach}
{/if}
<br><br>

{#SHOP2_ORDERING_INFO#} <br>
{#SHOP2_ORDER_NUMBER#}:
{$order.number} ({$order.order_id})
<br>
{if $order_form_settings.status}
		{#SHOP2_ORDER_STATUS#}:
		{$order.order_status_name|default:"-"}
		<br>
{/if}

{if $order_form_settings.date_ordering}
	{#SHOP2_CREATED#}:
		{$order.created|date_format:"%d.%m.%Y %H:%M"}
		<br>
{/if}

{if $order.created!=$order.modified && $order_form_settings.date_last_change}
	{#SHOP2_CHANGED#}:
		{$order.modified|date_format:"%d.%m.%Y %H:%M"}
		<br>
{/if}

{if $order_form_settings.paid_sum}
	{#SHOP2_PAID_SUM#}: 
		{$order.payment_total|price_convert} {#SHOP2_OUT_OF#} {$order.total|price_convert} {$currency_shortname}
		<br>
{/if}

<br>
{if $order.data.payment.name && $order_form_settings.payments}
		{#SHOP2_PAYMENTS#}:
		{$order.data.payment.name}
		<br>
{/if}


{if $order.is_public_comment}
		{#SHOP2_COMMENT_TO_ORDER#}
		{$order.comment|nl2br}
		<br>
{/if}

<br>
{#SHOP2_PRODUCTS_LIST#}: <br>
	{assign var="uv_order" value=''}
	{assign var="uv_preorder" value=''}
	{assign var="gifts" value=''}

	{foreach from=$order.products item=e}
		{capture assign="uv_product"}

			{assign var="params" value=$e.data.custom_params|@count}
			{if !$params}
				{assign var="params" value=1}
			{/if}

			{section loop=$params name=foo}
				{assign var="n" value=$smarty.section.foo.index}
				{assign var="custom_prm" value=$e.data.custom_params[$n]}
							{if !$e.gift}
								&nbsp;&nbsp;&nbsp;{#SHOP2_PRODUCT_NAME#}: 
								{if $e.data.article && $order_form_settings.article}
									<br>
									{#SHOP2_PRODUCT_ARTICLE#}: {$e.data.article}
									<br>
								{/if}
								{$e.data.name|htmlspecialchars} <br>
							{/if}
						{if $e.data.vendor_name && $order_form_settings.vendor}
							{#SHOP2_VENDOR#}: {$e.data.vendor_name} <br>
						{/if}

						{if $order_form_settings.dimensions && $e.data.length && $e.data.width && $e.data.height}
							{#SHOP2_DIMENSIONS#}: {$e.data.length}x{$e.data.width}x{$e.data.height} {#SHOP2_MM#} <br>
						{/if}
						{if $e.data.discounts_applied}
							{assign var="discount_id" value=$e.data.discounts_applied.0}
							{assign var="discount" value=$order.discounts.$discount_id}
							<p><em>{#SHOP2_DISCOUNT2#}: {$discount.discount_name}</em></p>
						{/if}

					{if $custom_prm.amount}
						{assign var="amount" value=$custom_prm.amount/1}
					{else}
						{assign var="amount" value=$e.amount/1}
					{/if}
					{if $e.gift}
						{capture append="gifts"}
							{assign var="n" value=$smarty.section.foo.index}
							{assign var="custom_prm" value=$e.data.custom_params[$n]}
							{$e.data.name} <br>
							&nbsp;&nbsp;&nbsp;<em>{#SHOP2_GIFT#}</em>
							<br>
							&nbsp;&nbsp;&nbsp;{#SHOP2_AMOUNT#}: {$e.amount/1} {if $order_form_settings.measure}{$e.data.unit}{/if}<br>
							{if $order_form_settings.weight}
								{if $order_form_settings.weight}&nbsp;&nbsp;&nbsp;{#SHOP2_WEIGHT#}: 
			{/if}{if $e.data.weight != 0}{$e.amount*$e.data.weight} {$e.data.weight_unit} {else} - {/if}<br>
							{/if}
						{/capture}
					{else}
						&nbsp;&nbsp;&nbsp;{#SHOP2_PRICE#}, {$currency_shortname}: {$e.price|price_convert}<br>
						&nbsp;&nbsp;&nbsp;{#SHOP_DISCOUNTED_PRICE#}, {$currency_shortname}: {$e.price_discounted|price_convert}<br>
						&nbsp;&nbsp;&nbsp;{#SHOP2_AMOUNT#}: {$amount} {if $order_form_settings.measure}{$e.data.unit}{/if}<br>
						&nbsp;&nbsp;&nbsp;{#SHOP2_WEIGHT#}: 
						{if $order_form_settings.weight}
							{if $e.data.weight != 0}{$amount*$e.data.weight} {$e.data.weight_unit} {else} - {/if}<br>
						{/if}
							{if $custom_prm.amount}
								&nbsp;&nbsp;&nbsp;{$custom_prm.total|price_convert}
							{else}
								&nbsp;&nbsp;&nbsp;{#SHOP2_SUM#}, {$currency_shortname}: {$e.total|price_convert} <br> <br>
							{/if}
						
					{/if}
					<br>
			{/section}
		{/capture}

		{if $e.pre_order == 1}
			{assign var="uv_preorder" value=$uv_preorder|cat:$uv_product}
		{else}
			{assign var="uv_order" value=$uv_order|cat:$uv_product}
		{/if}
	{/foreach}
	{$uv_order}

	{#SHOP2_GIFTS#}:
	{foreach from=$gifts item=gift}
		&nbsp;&nbsp;{$gift}
		<br><br>
	{/foreach}

	{if $uv_preorder}
			{$shop2.my.preorder_alias|default:#SHOP2_PREORDER2#}
		
		{$uv_preorder}
	{/if}


	{if $order.delivery.cost || $order.discounts}
			{#SHOP2_SUM#}:
			{$order.data.totals.sum_products|price_convert}
			<br>
	{/if}

	{if $order.discounts}
		{foreach from=$order.discounts item=discount key=k}
			{if !$discount.is_product}
			{$discount.discount_name}:
						{if $discount.discount_type == 'sum'}
							{if $discount.discount_kind == 6 || $discount.is_common || !$discount.discount_kind}{*is_common or manual*}
								{$discount.value} {$currency_shortname} {*$order.currency.currency.shortname|default:$shop.currency_shortname*}
							{else}{*is_product*}
								{$discount.discount_sum|price_convert} {*$order.currency.currency.shortname|default:$shop.currency_shortname*}
							{/if}
						{elseif $discount.discount_type == 'percent'}
							{$discount.value} %
						{elseif $discount.discount_type == 'amount'}
							{$discount.amount} по цене {$discount.amount-$discount.value}
						{else}
							{if isset($gifts[$discount.gift_id])}
								{$gifts[$discount.gift_id]}
							{else}
								{$discount.value}
							{/if}
							шт.
						{/if}
			{/if}
		{/foreach}
		<br>
			{#SHOP2_SUM_OF_DISCOUNT#}:
				{$order.total-$order.data.delivery.cost|price_convert}
			
	{/if}

	{if $order.data.tax.name}
		
			{#SHOP2_INCLUDING_VAT#|sprintf:$order.data.tax.name} {$order.data.tax.percent}%
			{$order.data.tax.value|price_convert}<br>
	{/if}

	{if $order.delivery.cost > 0}
		
			{#SHOP2_DELIVERY2#}
			{$order.delivery.cost|price_convert}
	{/if}

		{#SHOP2_AMOUNT_TO_PAY#}:
		{$order.total|price_convert}<br><br>
{/if}
{#SHOP2_ORDER_CANCELLING_INFO_TEXT#}
<br><br>
<a href="{$url}/my/s3/api/shop2/?cmd=cancelOrderNotify&order_id={$order.order_id}&hash={$api_order_cancellation_notify}&ver_id={$shop.ver_id}&shop_id={$shop.shop_id}&attach_id={$attach_id}&cancel=1"
	target="_blank">{#SHOP2_ORDER_CANCELLATION_BTN#}</a>&nbsp;
<a href="{$url}/my/s3/api/shop2/?cmd=cancelOrderNotify&order_id={$order.order_id}&hash={$api_order_cancellation_notify}&ver_id={$shop.ver_id}&shop_id={$shop.shop_id}&attach_id={$attach_id}&cancel=0"
	target="_blank">{#SHOP2_ORDER_NO_CANCELLATION_BTN#}</a>
{if $order}
	<div class="text-right">
		<a class="shop2-btn" href="#" id="order-print">{#SHOP2_PRINT_ORDER_FORM#}</a>
		{foreach from=$payments key=id item=e}
			{if $e.params.template}
				<a href="/my/s3/api/shop2/?cmd=printOrder&type={$e.code}&template={$e.params.template}&order_id={$order.order_id}&hash={$api_print_order}&ver_id={$shop2.ver_id}&shop_id={$shop2.shop_id}&attach_id={$e.attach_id}" target="_blank" class="shop2-btn">{$e.rename|default:$e.name}</a>
			{/if}
		{/foreach}
	</div>
	
	<div id="shop2-order">
		{include file="global:shop2.v2-order-table-products.tpl"}
	</div>
	
	{include file="global:shop2.v2-payment-btn.tpl"}
	{include file="global:shop2.v2-forms-btn.tpl"}
	
{/if}
{if $user.user_id}
	{if $orders}
		{if !$order}
		<table class="shop2-table-order">
			<thead>
				<tr>
					<th>№</th>
					<th>{#SHOP2_CREATED#}</th>
					<th>{#SHOP2_SUM#},&nbsp;{$currency.currency_shortname}</th>
					<th>{#SHOP_ORDER_PAYMENT_STATUS#}</th>
					<th>{#SHOP_ORDER_STATUS#}</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				{foreach from=$orders item=e}
				<tr>
					<td>{$e.number} ({$e.order_id})</td>
					<td>{$e.created|date_format:"%d.%m.%Y %H:%M"}</td>
					<td>{$e.total|price_convert}</td>
					<td>{if $e.paid==1}{#SHOP2_PAID#}{else}{#SHOP2_NOT_PAID#}{/if}</td>
					<td>{$e.order_status_name|default:"-"}</td>
					<td><a href="{url_param_replace order_id=$e.order_id}">{#SHOP2_MORE#} &raquo;</a></td>
				</tr>
				{/foreach}
			</tbody>
		</table>
		{/if}
	 {else}
		{if !$order}
			{#SHOP2_NO_ORDERS#}
		{/if}
	 {/if}
{/if}

{* Отменить заказ *}
{if $cancel_on}
	<div class="text-right">
		<button class="shop2-btn order-cancelling" data-cancelling-title="{#SHOP2_ORDER_CANCELLING_TITLE#}" data-cancelling-close="{#CLOSE#}" data-cancelling-button-title="{#SHOP2_ORDER_CANCELLATION_BTN#}" data-href="/my/s3/api/shop2/?cmd=cancelOrder&order_id={$order.order_id}&hash={$api_order_cancellation}&ver_id={$shop2.ver_id}&shop_id={$shop2.shop_id}&attach_id={$e.attach_id}" class="shop2-btn">
			{#SHOP2_ORDER_CANCELLATION_BTN#}
		</button>
	</div>
{/if}
{* /Отменить заказ *}
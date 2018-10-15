<div id="shop2-cart-preview">
	<div class="shop2-block cart-preview {if $smarty.cookies.cart_opened==1 || $shop2_cart.total_amount || $shop2_cart.total_pre_order}opened{/if}">
		<div class="block-title">
			<strong>{#SHOP2_MY_CART#}</strong>
			<span>&nbsp;</span>
		</div>
		<div class="block-body">
			{if $shop2_cart.total_amount==0 && $shop2_cart.total_pre_order==0}
				<div>{#SHOP2_YOUR_CART_EMPTY#}</div>
			{else}
				<p><span>{#SHOP2_PRODUCTS2#}:</span> <strong>{$shop2_cart.total_amount|default:0}</strong></p>
				<p><span>{#SHOP2_CART_TOTAL#}:</span>
					<strong>{$shop2_cart.total_sum|default:'0'|price_convert} {$shop2.currency_shortname}</strong></p>
				<p><span>{$shop2.my.preorder_alias|default:#SHOP2_PREORDER2#}:</span>
					<strong>{$shop2_cart.total_pre_order|default:0}</strong></p>
				<div class="clear-container"></div>
				<p><a href="{get_seo_url mode='cart' uri_prefix=$shop2.uri}" class="order-btn">{#SHOP2_CHECKOUT#}</a></p>
			{/if}
		</div>
	</div>
</div><!-- Cart Preview -->
{assign var="hide_auth_form" value=$shop2.json.hide_auth_form}

{if !$cart.cart}
	<p>{#SHOP2_CART_IS_EMPTY#} <a class="shop2-btn" href="{$shop2.uri}">{#SHOP2_GO_MAIN#}</a></p>
{else}

	{if $cart.totals.total < $shop2.json.order_min_cost}
		<div class="shop2-warning">
			<h2>{#SHOP2_MINIMUM_ORDER_AMOUNT#} - {$shop2.json.order_min_cost|price_convert} {$shop2.currency_shortname}</h2>
		</div>
	{/if}

	{include file="global:shop2.v2-order-errors.tpl"}


	<form action="{$shop2.uri}?mode=cart&action=up" id="shop2-cart">
		<p class="text-right">
			<a href="{$shop2.uri}?mode=cart&action=cleanup" class="shop2-btn">{#SHOP2_CLEAR_CART#}</a>
		</p>
		<table class="shop2-cart-table">
			{if $cart.discounts.subtotal != 0 || $cart.discounts.total != 0}
				{assign var="show_discount" value=1}
			{else}
				{assign var="show_discount" value=0}
			{/if}
			<tr>
				<th>{#SHOP2_PRODUCT#}</th>
				<th>{#SHOP2_PRICE#}, {$currency.currency_shortname}</th>
				{if $show_discount}<th>{#SHOP2_WITH_DISCOUNT#}, {$currency.currency_shortname}</th>{/if}
				<th>{#SHOP2_QTY#}</th>
				<th>{#SHOP2_SUM#}, {$currency.currency_shortname}</th>
				<th>&nbsp;</th>
			</tr>
			{foreach from=$cart.cart item=e key=k}
				{include file="global:shop2.v2-cart-product.tpl" fix_discount=1 show_discount=$show_discount}
			{/foreach}
			{foreach from=$cart.gifts item=e key=k}
				{include file="global:shop2.v2-cart-product.tpl" gift=1 fix_discount=1 show_discount=$show_discount}
			{/foreach}
		</table>
		<p class="text-right shop2-cart-update">
			<a href="#" class="shop2-btn shop2-cart-update">{#SHOP2_RECALCULATE#}</a>
		</p>
		<table class="shop2-cart-total">
			<tr>
				<td>&nbsp;</td>
				<th>{#SHOP2_SUM#}:</th>
				<td>{$cart.totals.discount_subtotal|price_convert} {$currency.currency_shortname}</td>
			</tr>

			{assign var="cpn" value=""}
			{capture assign="dsc"}{strip}
				{foreach from=$cart.details item=e name=foo}
					{assign var="discount" value=$discounts[$e.discount_id]}
					{if !$discount.is_coupon}
						{$discount.discount_descr}
					{else}
						{assign var="cpn" value=$cpn|cat:$discount.discount_descr}
					{/if}
				{/foreach}
			{/strip}{/capture}

			{if $cart.totals.sum_discount_order}
				<tr>
					<td>&nbsp;</td>
					<th>{strip}

							{if $dsc}
								<span class="question">
									<img src="/g/shop2v2/default/images/question-price.png" alt="" /> {#SHOP2_DISCOUNT2#}:
								</span>
								<div class="shop2-product-discount-desc">
									{$dsc}
								</div>
							{else}
								{#SHOP2_DISCOUNT2#}:
							{/if}

						{/strip}</th>
					<td>{$cart.totals.sum_discount_order|price_convert} {$currency.currency_shortname}</td>
				</tr>
			{/if}

			{if ($has_coupons || $coupons) && $cart.totals.total > 0}
				<tr>
					<td>
						<div class="shop2-coupon">
							<div class="coupon-body">
								<label class="coupon-label" for="coupon">{#SHOP2_CUPON#}:</label>
								<button class="coupon-btn shop2-btn">{#SHOP2_APPLY#}</button>
								<label class="coupon-field">
									<input type="text" id="coupon" value="" />
								</label>
							</div>
							<div class="coupon-arrow"></div>

							{if $coupons_arr}
							    <div class="coupon-id">
						            <span>{#SHOP2_USED#}:</span>
						            {foreach from=$coupons_arr key=k item=e}
						                <span class="coupon-code
						                    {if $e.err || $e.id<=0} error{/if}">{$k|escape}
						                    {if $e.err}({$e.err|localize}){elseif $e.id<=0}({#SHOP2_WRONG#}){/if}
						                </span>
						                <a href="#" data-code="{$k|escape}" class="coupon-delete">&nbsp;</a>
						            {/foreach}
							    </div>
							{elseif $coupons}
							    <div class="coupon-id">
						            <span>{#SHOP2_USED#}:</span>
						            {foreach from=$coupons key=k item=e}
						                <span class="coupon-code {if $e<=0} error{/if}">{$k|escape} {if $e<=0}({#SHOP2_WRONG#}){/if}</span>
						                <a href="#" data-code="{$k|escape}" class="coupon-delete">&nbsp;</a>
						            {/foreach}
							    </div>
							{/if}
						</div>
					</td>
					<th>{strip}

							{if $cpn}
								<span class="question">
									<img src="/g/shop2v2/default/images/question-price.png" alt="" /> {#SHOP2_COUPON_DISCOUNT#}:
								</span>
								<div class="shop2-product-discount-desc">
									{$cpn}
								</div>
							{else}
								{#SHOP2_COUPON_DISCOUNT#}:
							{/if}

						{/strip}</th>
					<td>{$cart.totals.sum_discount_coupon|price_convert} {$currency.currency_shortname}</td>
				</tr>
			{/if}


			{if $cart.tax.name}
				<tr>
					<td>&nbsp;</td>
					<th>{#SHOP2_INCLUDING_VAT#|sprintf:$cart.tax.name} {$cart.tax.percent}%:</th>
					<td>{$cart.tax.value|price_convert} {$currency.currency_shortname}</td>
				</tr>
			{/if}


			<tr>
				<td>&nbsp;</td>
				<th>{#SHOP2_TOTAL#}:</th>
				<td>{$cart.totals.total|price_convert} {$currency.currency_shortname}</td>
			</tr>
		</table>

	</form>

	<div class="shop2-clear-container"></div>

	{if !$hide_auth_form}
		{if isset($user.user_id)}
			{if $user.email}
				<div class="shop2-cart-registration">
					<div class="shop2-info">
						{#SHOP2_YOU_LOGGED_AS#|sprintf:$user.email}
					</div>
				</div>
			{/if}
		{else}

			{if $order_in_one_page}

			<div class="shop2-cart-auth">
				<div class="shop2-cart-auth__row">
					{*Cовершаете покупки впервые? Вы можете пройти несложную процедуру <a href="{get_seo_url mode=register uri_prefix=$user_settings.link}">Регистрации в магазине</a>*}
					{capture assign="__tmp"}{get_seo_url mode=register uri_prefix=$user_settings.link}{/capture}
					{#SHOP2_AUTH_REGISTRATION#|sprintf:$__tmp}
				</div>
				{*ВКЛЮЧИТЬ ЛОКАЛИЗАЦИЮ И ПРОПИСАТЬ ID=g-auth__shop2-checkout-btn*}
				<div class="shop2-cart-auth__row">
					<a href="#" class="shop2-cart-auth__expand js-shop2-cart-auth__expand">Войдите в Личный кабинет</a>, если совершали покупки ранее.
					{*#SHOP2_AUTH_WITH#*}
				</div>

				<form class="shop2-cart-auth__form js-shop2-cart-auth__form" method="post" action="{$user_settings.link}">
					<input type="hidden" name="mode" value="login" />
					<label class="shop2-cart-auth__label">
						{#SHOP2_LOGIN#}: <input type="text" class="shop2-cart-auth__input" name="login" />
					</label>
					<label class="shop2-cart-auth__label shop2-cart-auth__label--password">
						{#SHOP2_PASSWORD#}: <input type="text" class="shop2-cart-auth__input" name="password" />
					</label>
					<button class="shop2-btn" type="submit">{#SHOP2_LOG_IN_PLACE_ORDER#}</button>
					{if $user_settings.social_params}
						<div class="shop2v2-cart-soc-block">
							{include file="global:block.g-social.tpl"}
						</div>
						{/if}
				</form>

				<div class="shop2-cart-auth__row shop2-cart-auth__row--top-offset">
					{*Или продолжите оформление заказа <strong>без регистрации</strong>.*}
					{#SHOP2_AUTH_WITHOUT#}
				</div>
			</div>

			{else}
				
				<div class="shop2-cart-registration">
					<h2>{#SHOP2_CHECKOUT#}</h2>
					<table class="table-registration">
						<tr>
							<td class="cell-l">
								<form method="post" action="{$user_settings.link}" class="form-registration">
									<input type="hidden" name="mode" value="login" />
									<div>
										<label for="reg-login">{#SHOP2_LOGIN#}:</label>
										<label class="registration-field">
											<input type="text" id="reg-login" value="" name="login" />
										</label>
									</div>
									<div>
										<label for="reg-password">{#SHOP2_PASSWORD#}:</label>
										<label class="registration-field">
											<input type="password" id="reg-password" value="" name="password" />
										</label>
									</div>
									<button class="shop2-btn" type="submit">{#SHOP2_LOG_IN_PLACE_ORDER#}</button>
								</form>
								{if $user_settings.social_params}
								<div class="shop2v2-cart-soc-block">
									{include file="global:block.g-social.tpl"}
								</div>
								{/if}
							</td>
							<td class="cell-r">
								<p>{#SHOP2_FOR_DISCOUNTS_REGISTER1#} <a href="{get_seo_url mode=register uri_prefix=$user_settings.link}">{#SHOP2_FOR_DISCOUNTS_REGISTER2#}</a></p>
								{if !$order_in_one_page}
									<p><a href="{$shop2.uri}?mode=order" class="shop2-btn">{#SHOP2_BUY_WITHOUT_REGISTRATION#}</a></p>
								{else}
									<br/>
									<br/>
								{/if}
							</td>
						</tr>
					</table>
				</div><!-- Cart Registration -->
				
			{/if}


		{/if}
	{/if}

	{$shop2.json.order_note}

	{if $order_in_one_page}
		{if $cart.totals.total >= $shop2.json.order_min_cost}
			{include file="global:shop2.v2-cart.order.tpl"}
		{/if}
	{elseif $hide_auth_form || isset($user.user_id)}
		<p class="text-center"><a href="{$shop2.uri}?mode=order" class="shop2-btn">{#SHOP2_CHECKOUT#}</a></p>
	{/if}

{/if}
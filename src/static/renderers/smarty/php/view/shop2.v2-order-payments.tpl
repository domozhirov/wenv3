{if $payments || $payment_systems}
	<form method="post" action="#" class="shop2-order-options">
		<div class="options-list">
			{assign var="checked" value=0}
			{foreach from=$payments item=e key=k name=foo}
				<div class="option-type {if $smarty.foreach.foo.first}active-type {assign var="checked" value=1}{/if}">
					<label class="option-label">
						<input name="payment_id" value="{$k}" autocomplete="off" {if $smarty.foreach.foo.first}checked="checked"{/if} type="radio" />
						<span class="label-name">
							{strip}
								{if $e.rename}{$e.rename}{else}{$e.name}{/if}
								{assign var="cost" value=$pre_order.delivery.cost|default:0}
								{if $e.params.pricecash}
									<br />
									{#SHOP2_COST_INCREASE#} {$e.params.pricecash-$cost|price_convert} {$shop2.currency_shortname}
								{/if}
								{if $e.params.transfer}
									<br />
									+{#SHOP2_SURCHARGE_REMITTANCE#}: {$e.params.transfer|price_convert} {$shop2.currency_shortname}
								{/if}
							{/strip}
						</span>
					</label>
					{if $e.params.settings}
						{assign var=user_fields value=$e.params.settings}
					{else}
						{assign var=user_fields value=$e.user_fields}
					{/if}
					{if $user_fields}
						<div class="option-details">
							{foreach from=$user_fields key=k_field item=v_field}
							{if $v_field.switch}
							{assign var=autocomplete value=$v_field.autocomplete}
								<div class="option-item">
									<label>
										<span>{$v_field.name}: {if $v_field.required}<span class="required">*</span>{/if}</span>
										{if $v_field.type == 'text'}
											<input name="{$k}[{$k_field}]" type="text" size="{$v_field.size|default:'30'}" maxlength="{$v_field.maxlength|default:'100'}" value="{if $v_field.value}{$v_field.value}{else}{$user.$autocomplete}{/if}" />
										{elseif $v_field.type == 'textarea'}
											<textarea name="{$k}[{$k_field}]" class="{$k_field}" cols="50" rows="3">{if $v_field.value}{$v_field.value}{else}{$user.$autocomplete}{/if}</textarea>
										{/if}
									</label>
								</div>
							{/if}
							{/foreach}
						</div>
					{/if}
				</div>
			{/foreach}
			{if $payment_systems}
				{foreach from=$payment_systems item=e name=foo}
					<div class="option-type {if !$checked && $smarty.foreach.foo.first}active-type{/if}">
						<label class="option-label">
							<input name="payment_id" value="-{$e.type_id}" {if !$checked && $smarty.foreach.foo.first}checked="checked"{/if} type="radio" />
							<span class="label-name">
								{$e.system_name}
								{if !$e.specify_method && $e.markup !='0'}({#ACCOUNT_MARKUPS_TITLE#} {$e.markup|round:2}%){/if}
							</span>
							{if $e.specify_method && $site.s3_version >= "3.44"}
								<span class="label-icons">
									{assign var=payment_method_count value=$e.payment_methods|@count}
									{assign var=payment_method_count value=$payment_method_count/2}
									{foreach from=$e.payment_methods key="method_id" item=ee name=methods}
										{if $smarty.foreach.methods.first}
											<span class="payment_methods-column">
										{/if}
										<label data-count={$payment_method_count|round}>
											<input type="radio" name="-{$e.type_id}[method_id]" value="{$method_id}" {if $smarty.foreach.methods.first} checked="checked"{/if} />
											<img src="/g/s3/s3_shop2/payments/medium/ic_{$ee}.png" alt="" />
											{if $e.markups[$ee] && $e.markups[$ee]!=0}({#ACCOUNT_MARKUPS_TITLE#} {$e.markups[$ee]|round:2}%){/if}
										</label>
										{if $payment_method_count > 1 && $payment_method_count|round == $smarty.foreach.methods.iteration && !$smarty.foreach.methods.last}
											</span>
											<span class="payment_methods-column">
										{/if}
										{if $smarty.foreach.methods.last}
											</span>
										{/if}
									{/foreach}
								</span>
							{else}
								<span class="label-icons">
								{foreach from=$e.payment_methods item=ee}
									<img src="/g/s3/s3_shop2/payments/medium/ic_{$ee}.png" alt="" />
								{/foreach}
								</span>
							{/if}
						</label>
					</div>
				{/foreach}
			{/if}
		</div>

		<input type="hidden" name="step" value="payments" />
		<input type="hidden" name="mode" value="order" />
		<input type="hidden" name="action" value="save" />
		<input type="hidden" name="amount" value="{$order.total}" />
		<input type="hidden" name="shop_id" value="{$order.shop_id}" />

		<div class="text-center">
			<button class="shop2-btn" type="submit">{#SHOP2_TO_CONTINUE#}</button>
		</div>
	</form>
	<!-- Payment -->
{/if}
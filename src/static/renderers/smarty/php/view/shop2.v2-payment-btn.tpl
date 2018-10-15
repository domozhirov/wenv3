{if !$order.paid && $order.data.payment.ps}

	{if $mode == 'orders'}
		{assign var="data" value=$payment_systems}
	{else}
		{assign var="data" value=$payment_system}
	{/if}

	{if $data}

		<form method="GET" action="" class="shop2-payments-order">

			<input type="hidden" name="mode" value="{$mode}"/>
			<input type="hidden" name="action" value="pay"/>
			<input type="hidden" name="amount" value="{$order.total}"/>
			<input type="hidden" name="order_id" value="{$order.order_id}"/>
			<input type="hidden" name="shop_id" value="{$order.shop_id}"/>

			{if $mode == 'order' && $step == 'payment'}

				<input type="hidden" name="ps" value="{$payment_system.system_type_id}" />
				<input type="hidden" name="step" value="payment" />

				<p>
					{#SHOP2_SELECTED_PAYMENT_SYSTEM#}:
					<strong>{$data.system_name} {if $payment_system.markup}({#ACCOUNT_MARKUPS_TITLE#} {$payment_system.markup|round:2}%){/if}</strong>
					<button class="shop2-btn" type="submit">{#SHOP2_PAY#}</button>
				</p>

			{else}

				{if !$user}
					<input type="hidden" name="hash" value="{$smarty.get.hash}" />
				{/if}

				{assign var="payment_id" value=$order.data.payment.payment_id}
				{assign var="payment_method_id" value=$order.data.payment.method_id}

				{foreach from=$data name=foo item=e key=k}
					<label class="shop2-payment-type">
						<input type="radio" name="ps" value="{$e.type_id}" {if $e.type_id == $payment_id}checked="checked"{/if} />
						{$e.system_name}
						{if !$e.specify_method && $e.markup !='0'}({#ACCOUNT_MARKUPS_TITLE#} {$e.markup|round:2}%){/if}
					</label>

					{if $e.specify_method}
						<span class="label-icons shop2-payment-methods">
							{foreach from=$e.payment_methods key="method_id" item=ee name=methods}
								{if $smarty.foreach.methods.first}
									<span class="payment_methods-column">
								{/if}

								<label>
									<input type="radio" name="-{$e.type_id}[method_id]" value="{$method_id}" {if $e.type_id == $payment_id && $method_id == $payment_method_id}checked="checked"{/if} />
									<img src="/g/s3/s3_shop2/payments/medium/ic_{$ee}.png" alt="" />
									{if $e.markups[$ee] && $e.markups[$ee]!=0}({#ACCOUNT_MARKUPS_TITLE#} {$e.markups[$ee]|round:2}%){/if}
								</label>

								{if $smarty.foreach.methods.iteration%3 == 0 && !$smarty.foreach.methods.last}
									</span>
									<span class="payment_methods-column">
								{/if}

								{if $smarty.foreach.methods.last}
									</span>
								{/if}
							{/foreach}
						</span>
					{else}
						<span class="label-icons shop2-payment-methods">
							{foreach from=$e.payment_methods item=ee}
								<img src="/g/s3/s3_shop2/payments/medium/ic_{$ee}.png" alt="" />
							{/foreach}
						</span>
					{/if}
				{/foreach}

				<button class="shop2-btn" type="submit">{#SHOP2_PAY#}</button>

			{/if}

		</form>

	{/if}

{/if}
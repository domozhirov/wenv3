<form action="{$form_action}" method="post" class="shop2-cart-order-form shop2-order-in-one-page-form">
	{if $deliveries}
		<h2>{#SHOP2_DELIVERY2#}</h2>
		<div class="shop2-order-options shop2-delivery">
			<div class="options-list">
				{foreach from=$deliveries item=e key=k name="deliveries"}
					{assign var="cur" value=0}
					{if $delivery.attach_id}
						{if $delivery.attach_id == $k}
							{assign var="cur" value=1}
						{/if}
					{elseif $smarty.foreach.deliveries.first}
						{assign var="cur" value=1}
					{/if}
					<div class="option-type {if $cur}active-type{/if}">
						<label class="option-label">
							<input name="delivery_id" type="radio" autocomplete="off" {if $cur}checked="checked"{/if}
								   value="{$k}" />
							<span>
								{$e.name|htmlspecialchars}

								{if $e.code != 'ems' && $e.code != 'edost'}
									{if $e.cost==0}

										{if $e.delivery_info}
											- {$e.delivery_info}
										{else}
											{if !$shop2.my.hide_delivery_cost}- {#SHOP2_FREE#}{/if}
										{/if}

									{else}
										- {$e.cost|price_convert} {$currency.currency_shortname}
									{/if}

								{/if}

								{if $e.term}({$e.term}){/if}
							</span>
						</label>
						{if $e.fields|@count}
							<div class="option-details">
								{foreach from=$e.fields item=v_field key=k_field}
									{if $v_field.type == 'textarea'}
										<div class="option-item">
											<label>
												<span>{$v_field.name|htmlspecialchars} {if $v_field.required}
														<span class="required">*</span>
													{/if}</span>
												<textarea name="{$k}[{$k_field}]" {if !$cur}disabled="disabled"{/if}
														  cols="50" rows="5" class="shop2-textarea">{strip}
														{if $delivery.attach_id == $k}
														{$delivery[$k_field]|htmlspecialchars}
													{else}
														{$v_field.value}
													{/if}
													{/strip}</textarea>
											</label>
										</div>
									{elseif $v_field.type == 'text'}
										<div class="option-item">
											<label>
												<span>{$v_field.name|htmlspecialchars} {if $v_field.required}
														<span class="required">*</span>
													{/if}</span>
												<input class="shop2-input" name="{$k}[{$k_field}]" {if !$cur}disabled="disabled" {/if}type="text"
													   size="{$v_field.size|default:30}"
													   maxlength="{$v_field.maxlength|default:100}" value="{strip}
									{if $delivery.attach_id == $k}
										{$delivery[$k_field]|htmlspecialchars}
									{else}
										{$v_field.value}
									{/if}
								{/strip}" />
											</label>
										</div>

									{elseif $v_field.type == 'checkbox'}
										{if $e.code == 'ems'}
											{if $v_field.display}
												<div class="option-item">
													<label>
														<span>{$v_field.name|htmlspecialchars} {if $v_field.required}<span class="required">*</span>{/if}</span>
														<input type="checkbox" name="{$k}[{$k_field}]" />
													</label>
												</div>
											{/if}
										{else}
											<div class="option-item">
												<label>
													<span>{$v_field.name|htmlspecialchars} {if $v_field.required}<span class="required">*</span>{/if}</span>
													<input type="checkbox" name="{$k}[{$k_field}]" />
												</label>
											</div>
										{/if}
										
									{elseif $v_field.type == 'select'}

									{if $e.code == 'edost'}
										<script type="text/javascript" src="/g/s3/shop2/edost/1.0.0/shop2.edost.regions.js"></script>
										{capture assign="field_name"}
											<span>{$v_field.name|htmlspecialchars} {if $v_field.required}
													<span class="required">*</span>
												{/if}</span>
										{/capture}
										{if $e.params.countries}
											<div class="option-item">
												<label>
													{$field_name}
													{assign var="field_name" value=""}
													<select id="shop2-edost2-country" name="{$k}[country]"
															data-value="{$delivery.country|htmlspecialchars}">
														<option value="default">--{#COUNTRIES#}--</option>
													</select>
												</label>
											</div>
										{/if}
										{if $e.params.regions}
											<div class="option-item">
												<label>
													{$field_name}
													{assign var="field_name" value=""}
													<select id="shop2-edost2-region" name="{$k}[region]"
															data-value="{$delivery.region|htmlspecialchars}">
														<option value="default">--{#REGIONS#}--</option>
													</select>
												</label>
											</div>
										{/if}
											<div class="option-item">
												<label>
													{$field_name}
													<select id="shop2-edost2-city" name="{$k}[city]"
															data-value="{$delivery.city|htmlspecialchars}">
														<option value="default">--{#SHOP2_CITY#}--</option>
													</select>
												</label>
											</div>
											<input type="hidden" id="shop2-edost2-to" name="{$k}[{$k_field}]" value="{$delivery[$k_field]}" />
									{else}
										{if $e.code == 'ems' && $k_field =='to'}
											<div class="option-item">
												<label>
													<span>{$v_field.name|htmlspecialchars} {if $v_field.required}<span class="required">*</span>{/if}</span>
													<select id="delivery-{$k_field}" name="{$k}[{$k_field}]" {if !$cur}disabled="disabled"{/if}>
														<option value="">--{#SHOP2_SELECT_CITY#}--</option>
														{foreach from=$v_field.values item=v_value key=k_value}
															{if is_array($v_value)}
																<optgroup label="{$k_value}">
																	{foreach from=$v_value item=vv_value key=kk_value}
																		<option {if $delivery[$k_field] == $kk_value}selected="selected"{/if} value="{$kk_value}">{$vv_value|htmlspecialchars}</option>
																	{/foreach}
																</optgroup>
															{else}
																<option {if $delivery[$k_field] == $k_value}selected="selected"{/if} value="{$k_value}">{$v_value|htmlspecialchars}</option>
															{/if}
														{/foreach}
													</select>
												</label>
											</div>
										{else}
											<div class="option-item">
												<label>
													<span>{$v_field.name|htmlspecialchars} {if $v_field.required}<span class="required">*</span>{/if}</span>
													<select {if $v_field.select_type=='multi'}multiple{/if} id="delivery-{$k_field}" name="{$k}[{$k_field}][]" {if !$cur}disabled="disabled"{/if}>
														{if $v_field.select_type != 'multi'}<option value="">--{#SHOP2_SELECT_TYPE_SELECT#}--</option>{/if}
														{foreach from=$v_field.select item=v_value key=k_value}
															{if is_array($v_value)}
																<optgroup label="{$k_value}">
																	{foreach from=$v_value item=vv_value key=kk_value}
																		<option {if in_array($kk_value, $delivery[$k_field])}selected="selected"{/if} value="{$vv_value|htmlspecialchars}">{$vv_value|htmlspecialchars}</option>
																	{/foreach}
																</optgroup>
															{else}
																<option {if in_array($v_value, $delivery[$k_field])}selected="selected"{/if} value="{$v_value|htmlspecialchars}">{$v_value|htmlspecialchars}</option>
															{/if}
														{/foreach}
													</select>
												</label>
											</div>
										{/if}
									{/if}

										{if (($e.code == 'ems' && $k_field == 'to') || $e.code == 'edost') && $v_field.type == 'select'}
											<label>
												<a class="shop2-btn" href="#" data-attach-id="{$e.attach_id}" id="shop2-{$e.code}-calc">{#SHOP2_CALCULATE#}</a>
												{if $e.code == 'ems'}
													<span id="delivery-{$e.attach_id}-cost">0</span> {$shop2.currency_shortname}
												{/if}
											</label>
										{/if}
									{/if}
								{/foreach}

								{if $e.code == 'edost'}
									<div id="delivery-{$e.attach_id}-html">
										{include file="global:shop2.v2-order-delivery-edost.tpl" edost=$e.edost attach_id=$e.attach_id}
									</div>
								{/if}
							</div>
						{/if}
					</div>
				{/foreach}
			</div>
		</div>
	{/if}

	{if $form}
		<h2>{#SHOP2_ORDER_FORM#}</h2>
		<div class="shop2-order-form shop2-order-form--offset-left">

			{foreach from=$form key=name item=item}

				{capture assign="caption"}
					<strong>
						{$item.name|htmlspecialchars}
						{if $item.required}<span class="required">*</span>{/if}
					</strong>
				{/capture}

				<div class="form-item">
					{if $item.type == 'text' || $item.type == 'email' || $item.type == 'phone'}
						<label>
							{$caption}
							<input type="text" maxlength="{$item.maxlength|default:100}" size="{$item.size|default:50}"
								   name="order[{$name}]" id="user_{$name}" value="{$item.value|htmlspecialchars}" class="shop2-input" />
						</label>
					{elseif $item.type == 'textarea'}
						<label>
							{$caption}
							<textarea rows="{$item.rows|default:7}" cols="{$item.cols|default:50}" name="order[{$name}]"
									  id="user_{$name}" class="shop2-textarea">{$item.value}</textarea>
						</label>
					{elseif $item.type == 'radio'}

						{$caption}
						{foreach from=$item.values key=key item=val}
							<label class="order-form-options">
								<input type="radio" name="order[{$name}]"
									   value="{$key}"{if $key==$item.value} checked="checked"{/if} /> {$val}
							</label>
						{/foreach}

					{elseif $item.type == 'checkbox'}

						{$caption}
						{foreach from=$item.values key=key item=val name=foo}
							<div class="order-form-options">
								<label>
									<input type="checkbox" name="order[{$name}][{$key|htmlspecialchars}]"
										   value="{$key|htmlspecialchars}"
										   {if $key == $item.value}checked="checked"{/if} /> {$val|htmlspecialchars}
								</label>
							</div>
						{/foreach}

					{elseif $item.type == 'multi_checkbox'}

						{$caption}
						{foreach from=$item.values key=key item=val name=foo}
							<div class="order-form-options">
								<label>
									<input type="checkbox" name="order[{$name}][{$key|htmlspecialchars}]"
										   value="{$key|htmlspecialchars}" {if isset($item.value[$key])} checked="checked"{/if} /> {$val|htmlspecialchars}
								</label>
							</div>
						{/foreach}

					{elseif $item.type == 'select'}
						<label>
							{$caption}
							<select name="order[{$name}]">
								{foreach from=$item.values key=key item=val}
									<option value="{$key}" {if $key == $item.value} selected="selected"{/if}>{$val}</option>
								{/foreach}
							</select>
						</label>
					{elseif $item.type == 'multiselect'}
						<label>
							{$caption}
							<select name="order[{$name}][]" multiple="multiple" size="{$item.size|default:5}">
								{foreach from=$item.values key=key item=val}
									<option value="{$key}"{if in_array($key, $item.value)} selected="selected"{/if}>{$val}</option>
								{/foreach}
							</select>
						</label>
					{elseif $item.type == 'captcha'}
						<label>
							{$caption}
							{captcha name=$name}
						</label>
					{elseif $item.type == 'personal_data'}
						<label>
							<input type="checkbox" name="order[{$name}]" value="1" autocomplete="off" {if $item.value}checked{/if} />
							{$item.name}
							{if $item.required}<span class="required">*</span>{/if}
						</label>
						(<a href="#" onclick="return hs.htmlExpand(this, {ldelim}contentId:'order-personal-data-agreement', wrapperClassName: 'draggable-header', align: 'center', width: 600, height: 400{rdelim})">{#DETAILS#}</a>)
						<div class="highslide-html-content" id="order-personal-data-agreement">
							<div class="highslide-header">
								<ul>
									<li class="highslide-close"><a href="#" title="Close (esc)" onclick="return hs.close(this)"></a></li>
								</ul>
							</div>
							<div class="highslide-body">{$item.text}</div>
						</div>
					{/if}

					{if $item.note}
						<small>{$item.note}</small>
					{/if}
				</div>
			{/foreach}

		</div>
	{/if}

	<div class="form-item form-item-submit">
		<button type="submit" class="shop2-btn shop2-btn--large">{#SHOP2_CHECKOUT#}</button>
	</div>
</form>
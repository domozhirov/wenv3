{assign var="stripeClass" value="even"}
{capture assign="c_vendor"}{strip}
	{if !$shop2.my.hide_vendor_in_list || $mode == 'product'}

		{if $product.vendor_name}
			<tr class="even">
				<th>{$shop2.my.vendor_alias|default:#SHOP2_VENDOR#}</th>
				<td>
					{if !$shop2.my.hide_vendor_name}
						<a href="{get_seo_url uri_prefix=$shop2.uri mode="vendor" alias=$product.vendor_alias}">{$product.vendor_name}</a>
					{/if}
					
					{if $product.vendor_filename && $shop2.my.show_vendor_image}
						<div class="shop2-vendor">
							<a href="{get_seo_url uri_prefix=$shop2.uri mode="vendor" alias=$product.vendor_alias}">
								{assign var="width" value=$shop2.my.vendor_image_width|default:80}
								{assign var="height" value=$shop2.my.vendor_image_height|default:40}
								<img src="{s3_img src=$product.vendor_filename width=$width height=$height method="r"}" alt="{$product.vendor_name}" />
							</a>
						</div>
					{/if}
				</td>
			</tr>
		{/if}

	{/if}
{/strip}{/capture}

{capture assign="c_dimensions"}{strip}
	{if $shop2.my.show_dimensions_in_list}

		{if $product.length}
			{assign var="stripeClass" value="odd"}
			<tr class="odd">
				<th>{#SHOP2_PRODUCT_LENGTH#}</th>
				<td>
					{$product.length}
				</td>
			</tr>
		{/if}

		{if $product.width}
			{assign var="stripeClass" value="even"}
			<tr class="even">
				<th>{#SHOP2_PRODUCT_WIDTH#}</th>
				<td>
					{$product.width}
				</td>
			</tr>
		{/if}

		{if $product.height}
			<tr class="odd">
				{assign var="stripeClass" value="odd"}
				<th>{#SHOP2_PRODUCT_HEIGHT#}</th>
				<td>
					{$product.height}
				</td>
			</tr>
		{/if}

	{/if}
{/strip}{/capture}

{if $shop2.my.hide_options_in_list && $mode != 'product'}
	
	{*не показываем параметры в списке, но мультиселекты с not_mod там должны быть - чтобы параметр добавлялся в корзину*}
	{if $product_refs[$product.product_id] && $meta}
		{foreach from=$product_refs[$product.product_id] item=o_values key=o_name}
			{assign var="option" value=$meta.$o_name}
			{if $option.in_card}
				{if $option.type == 'multiselect'}
					{assign var="values" value=$product.meta[$o_name]}
					{if $values}
						{assign var="all_values" value=$meta.$o_name.options}
						{if $option.not_mod}
							{foreach from=$values item=value key=k name=foo}
								{if $smarty.foreach.foo.first}
									<input type="hidden" name="{$o_name}" class="additional-cart-params" value="{$option.name}: {$all_values.$value}">
								{/if}
							{/foreach}
						{/if}
					{/if}
				{/if}
			{/if}
		{/foreach}
	{/if}

	{if $c_vendor}
		<table class="shop2-product-options">{$c_vendor}</table>
	{/if}

{else} {*-----------------------------------------------------------------------------------------*}

	{include file="global:shop2.v2-product-compare-btn.tpl"}
	
	{capture assign="c_options"}{strip}
		
		{$c_vendor}

		{$c_dimensions}

		{if $product_refs[$product.product_id] && $meta}
			{foreach from=$product_refs[$product.product_id] item=o_values key=o_name}
				{assign var="option" value=$meta.$o_name}

				{if $option.type != 'html' && (($mode == 'product' && $option.in_detail) || ($mode != 'product' && $product.cf.$o_name.in_list))}
				<tr class="{if $stripeClass == "even"}{cycle values="odd,even"}{else}{cycle values="even,odd"}{/if}{if $option.type == 'color'} type-color{elseif $option.type == 'image2'} type-texture{elseif $option.type == 'select'} type-select{/if}">
					{if $option.type == 'color'}
		
						{* цвет ------------------------------- *}
						{if $o_values}
							
								<th>{$option.name}</th>
								<td>
									<ul class="shop2-color-pick">
										{foreach from=$o_values item=o_kinds key=o_color}
											<li data-kinds="{','|implode:$o_kinds}" data-name="{$o_name}" data-value="{$o_color|escape}" class="{if $o_color==$product.meta[$o_name]}active-color{/if} shop2-cf">
												<span style="background-color: {$o_color};">&nbsp;</span>
											</li>
										{/foreach}
									</ul>
								</td>
							
						{/if}
						{* /----------------------------------- *}
					
					{elseif $option.type=='select'}

						{* список ----------------------------- *}
						{if $o_values}
							{assign var="all_values" value=$meta.$o_name.options}
							{assign var="value" value=$product.meta[$o_name]}
							{if $o_values|@count == 1}
								{* одно значение *}
								{*assign var="kind_id" value=$o_values.$value.0}
								{if $kind_id == $product.kind_id && $value*}
								{if $value}
									
										<th>{$option.name}</th>
										<td>{$all_values.$value}</td>
									
								{/if}
								{* /------------ *}
							{else}
								{* больше *}
								
									<th>{$option.name}</th>
									<td>
										<select name="cf_{$o_name}" class="shop2-cf">
											{foreach from=$o_values item=o_kinds key=o_value}
												<option  value="{$o_value}" data-name="{$o_name}" data-value="{$o_value}" data-kinds="{','|implode:$o_kinds}" {if $value==$o_value}selected="selected"{/if}>{$all_values.$o_value}</option>
											{/foreach}
										</select>
									</td>
								
								{* /------------ *}
							{/if}
						{/if}
						{* /----------------------------------- *}
					

					{elseif $option.type == 'multiselect'}

						{* мультиселект --------------------------- *}
						{assign var="values" value=$product.meta[$o_name]}
						{if $values}
							{assign var="all_values" value=$meta.$o_name.options}
							
								<th>{$option.name}</th>
								<td>
									{if $option.not_mod}
										{* без модификаций *}
											<select name="{$o_name}" class="additional-cart-params">
												{foreach from=$values item=value key=k name=foo}
												<option value="{$option.name}: {$all_values.$value}">{$all_values.$value}</option>
												{/foreach}
											</select>										
										{* /-------------- *}
									{else}
										{foreach from=$values item=value key=k name=foo}
											{$all_values.$value}
											{if !$smarty.foreach.foo.last}, {/if}
										{/foreach}
									{/if}
								</td>
							
							{/if}
						{* /----------------------------------- *}
					

					{elseif $option.type == 'file2'}

						{* файл ------------------------------- *}
						{assign var="filename" value=$product.meta[$o_name].filename}
						{if $filename}
					
							<th>{$option.name}</th>
							<td>
								<a href="{$FILES_DIR}{$filename}" class="file"><span class="icon"></span>{#SHOP2_DOWNLOAD#}</a>
							</td>
					
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'image2'}

						{* картинка --------------------------- *}
						{capture assign="images"}{strip}
							{foreach from=$o_values item=o_kinds key=o_value}
								{if $o_value && $cf_images.$o_value}
									<li data-kinds="{','|implode:$o_kinds}" data-name="{$o_name}" data-value="{$o_value|escape}" class="{if $o_value == $product.meta[$o_name].image_id}active-texture{/if} shop2-cf">
										<img src="{s3_img width=30 height=30 src=$cf_images.$o_value method=$shop2.my.s3_img_method}" alt="{$option.name}" />
									</li>
								{/if}
							{/foreach}
						{/strip}{/capture}
						
						{if $images}
						
							<th>{$option.name}</th>
							<td>
								<ul class="shop2-texture-pick">
									{$images}
								</ul>
							</td>
						
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'textarea'}

						{* текст --------------------------- *}
						{assign var="text" value=$product.meta[$o_name]}
						{if $text || $text === '0'}
						
							<th>{$option.name}</th>
							<td>
								{$text}
							</td>
						
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'checkbox'}

						{* галочка --------------------------- *}
						{assign var="checked" value=$product.meta[$o_name]}
						{if $checked}
							<th>{$option.name}</th>
							<td>
								{if $checked}{#SHOP2_YES#}{else}{#SHOP2_NO#}{/if}
							</td>
						{/if}
						{* /----------------------------------- *}

					{elseif $option.type == 'text' || $option.type=='int' || $option.type=='float'}
						
						{* строка или число ------------------ *}
						{if $product.meta[$o_name] || $product.meta[$o_name] === '0'}
							
								<th>{$option.name}</th>
								<td>{$product.meta[$o_name]} {$option.unit}</td>
							
						{/if}
						{* /---------------------------------- *}

					{elseif $option.type == 'color_ref' || $option.type == 'color2'}
						
						{assign var="values" value=$product.meta[$o_name]}

						{if $values|@count}
							<th>{$option.name}</th>
							<td>
								{include file="global:shop2.v2-color-ext.tpl" location="product"}
							</td>
						{/if}
					{elseif $option.type == 'coordinates'}

						{assign var="coords" value=$product.meta[$o_name]}

						{if $coords.x}
							<th>{$option.name}</th>
							<td>
								<a href="#" class="shop2-map-link" data-map="{$coords|@json_encode|htmlspecialchars}" data-map-type="{$option.map_type|htmlspecialchars}">{$coords.title|default:$product.name|htmlspecialchars}</a>
							</td>
						{/if}
					{/if}
					</tr>
				{/if}
			{/foreach}
		{/if}
	{/strip}{/capture}
	
	{if $c_options}
		<table class="shop2-product-options">{$c_options}</table>
	{/if}

{/if}
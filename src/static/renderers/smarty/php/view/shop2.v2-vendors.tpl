{if $shop2.vendors}
	<ul class="shop2-vendors">
		{foreach from=$shop2.vendors item=e key=k name=foo}
			<li class="shop2-vendor">
				<a href="{get_seo_url mode=vendor alias=$e.alias}">
						<span class="vendor-logo {if !$e.image_id}no-logo{/if}">
						{if $e.image_id}
							<img src="{s3_img width=80 height=80 src=$e.filename method=$shop2.my.s3_img_method}" alt=""/>
							<span class="verticalMiddle"></span>
						{/if}
                    </span>
					<span class="vendor-name">{$e.name}</span>
				</a>
			</li>
		{/foreach}
	</ul>
{/if}
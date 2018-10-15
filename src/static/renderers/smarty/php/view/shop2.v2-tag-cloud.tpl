{if $tag_cloud}
	<div class="shop2-block tag-cloud opened">
		<div class="block-title">
			<strong>{#SHOP2_TAG_CLOUD#}</strong>
			<span>&nbsp;</span>
		</div>
		<div class="block-body">
			{strip}
				{foreach from=$tag_cloud item=e}
					<a href="{get_seo_url uri_prefix=$shop2.uri mode="tag" alias=$e.tag}">
						{$e.tag|htmlspecialchars}
						<em> {$e.cnt}</em>
						<span></span>
						<ins></ins>
					</a>
				{/foreach}
			{/strip}
		</div>
	</div>
{/if}
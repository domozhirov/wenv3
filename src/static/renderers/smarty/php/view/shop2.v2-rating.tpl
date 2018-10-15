{if $shop2.comment_settings.allow_rating == 1 || $shop2.comment_settings.allow_rating == 3}
	{capture assign="rating"}{strip}
		<div class="tpl-stars">
			<div class="tpl-rating" style="width: {$product.rating.value*20}%;"></div>
		</div>
	{/strip}{/capture}

	{strip}
		{if $mode == 'product'}
			<div class="tpl-rating-block">
				{#SHOP2_RATING#}:
				{$rating}
				({$product.rating.count|default:0|spellcount:#SHOP2_VOTE1#:#SHOP2_VOTE2#:#SHOP2_VOTE3#})
			</div>
		{else}
			{$rating}
		{/if}
	{/strip}

	{if $shop2.comment_settings.enable_rating_microdata == 1 && $product.rating.value >= 1}
		<div itemscope itemtype="http://schema.org/Product">
			<meta itemprop="name" content="{$product.name}">
			<meta itemprop="image" content="http://{$site.domain_mask}{s3_img width=$shop2.thumb_width height=$shop2.thumb_height src=$product.image_filename}">
			<link itemprop="url" href="http://{$site.domain_mask}{get_seo_url mode="product" alias=$product.alias}">
			{assign var="l_shop2_no_description" value="SHOP2_NO_DESCRIPTION"|l}
			<meta itemprop="description" content="{$product.note|default:$l_shop2_no_description}">

			<div itemprop="offers" itemscope itemtype="http://schema.org/Offer">
				<meta itemprop="price" content="{$product.price}">
				<meta itemprop="priceCurrency" content="{$currency.currency_symbol}">
			</div>

			<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
				<meta itemprop="ratingValue" content="{$product.rating.value|round}">
				<meta itemprop="ratingCount" content="{$product.rating.count}">
				<meta itemprop="bestRating" content="5">
				<meta itemprop="worstRating" content="1">
			</div>

		{*	<div itemprop="review" itemscope itemtype="http://schema.org/Review">
				<meta itemprop="author" content="{$site.site_domain}">
				<div itemprop="reviewRating" itemscope itemtype="http://schema.org/Rating">
					<meta itemprop="bestRating" content="5">
					<meta itemprop="worstRating" content="1">
					<meta itemprop="ratingValue" content="{$product.rating.value|round}">
				</div>
			</div> *}
		</div>
	{/if}
{/if}
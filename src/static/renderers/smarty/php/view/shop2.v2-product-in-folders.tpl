{if $product.folders && $shop2.my.show_sections}

    {capture assign="product_folders"}{strip}
        {foreach from=$product.folders item=e key=k name=foo}
            {if $e._level}
                <a href="{get_seo_url uri_prefix=$shop2.uri mode="folder" alias=$e.alias}">
                    {$e.folder_name}
                    <span></span>            
                </a>
            {/if}
        {/foreach}
    {/strip}{/capture}
    
    {if !empty($product_folders)}
        <h4 class="shop2-product-folders-header">{$shop2.my.located_in_sections_alias|default:#SHOP2_LOCATED_IN_SECTIONS#}</h4>
        <div class="shop2-product-folders">{$product_folders}</div>
    {/if}

{/if}
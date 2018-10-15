{strip}
    {if ! empty($site.reg.se.facets) && $site.reg.se.searcher == 'S3\\Shop2\\Search\\ElasticSearcher'}
        {assign var=facets_param value=$aggs[$field_name]}
        {assign var=facets_param_val value=$facets_param[$key]|default:0}

        {if $empty_class}{if !$empty_class_inset}class="{/if}{if empty($facets_param_val)} {$empty_class}{/if}"{/if}{if $placeholder} placeholder="{$facets_param_val}"{/if}{if $is_empty_disabled && empty($facets_param_val)} disabled="disabled"{/if} data-param-val="{$facets_param_val}{if !$empty_class_inset}"{/if}
    {/if}
{/strip}
{if $shop2.comment_settings.turned_on}
	{if $comments}
		<div class="tpl-block-header">{#SHOP2_REVIEWS#}</div>

		{foreach from=$comments item=e}
			<dl class="tpl-comment" id="comment-{$e.comment_number}">
				<dt class="tpl-header clearfix">
					<div class="tpl-name">{$e.author_name|default:#SHOP2_ANONYMOUS_VISITOR#}</div>
					{assign var="shop2_in" value="SHOP2_IN"|l}
					<time class="tpl-date" datetime="{$e.date_created|date_format_ex:"%Y-%m-%dT%H:%M"}">{$e.date_created|date_format_ex:"%d %B %Y `$shop2_in` %H:%M"}</time>
					{if $e.rating}
						<div class="tpl-stars">
							<div class="tpl-rating tpl-rating-{$e.rating}"></div>
						</div>
					{/if}
					<a class="tpl-link" href="#comment-{$e.comment_number}">#</a>
				</dt>
				<dd class="tpl-body">
					{$e.text|nl2br}
				</dd>
			</dl>
		{/foreach}

		{if $pglst == -1}
			{include file="global:shop2-pagelist.tpl"}
		{else}
			{include file="global:shop2.v2-pagelist.tpl"}
		{/if}

		<hr />

	{/if}

	{*if $user}
		<div class="tpl-user-info">{#USER#}: <span class="user-name">{$user.name}</span> <a href="{$user_settings.link}?mode=logout">{#SHOP2_LOG_OUT#}</a></div>
	{/if*}

	{if $form}

		{if $comments_success}<div class="tpl-info">{$comments_success}</div>{/if}
		{if $moderation_result}<div class="tpl-info">{$moderation_result}</div>{/if}

		{if !$moderation_result}

			<div class="tpl-block-header">{#SHOP2_LEAVE_REVIEW#}</div>

			<div class="tpl-info">
				{#BOARD_FILL_REQUIRED_FIELDS#} <span class="tpl-required">*</span>.
			</div>

			<form method="post" class="tpl-form">
				{foreach from=$form->controls item=control}
					{if $control->type == 0}
						<input type="hidden" name="{$control->name}" value="{$control->value}" />
					{elseif $control->type == 10}

						<div class="tpl-field">
							<div class="tpl-title">
								{#FORM_ENTER_CAPTCHA_CODE#}
								<span class="tpl-required">*</span>

								{if $control->error}
									<div class="tpl-error">{#WRONG_CAPTCHA_ERROR#}</div>
								{/if}
							</div>
							<div class="tpl-value">
								{captcha name="_cn"}
							</div>
						</div>
					{else}

						<div class="tpl-field">
							<label class="tpl-title">
								{$control->localized_name}:
								{if $control->required}
									<span class="tpl-required">*</span>
								{/if}
								{if $control->error && $control->error_message}
									<div class="tpl-error">{$control->error_message}</div>
								{/if}
							</label>

							<div class="tpl-value">
								{if $control->type == 1}
									<input type="text" size="40" name="{$control->name}" {if $control->params.maxlength}maxlength="{$control->params.maxlength}"{/if} {if $control->value}value ="{$control->value}"{/if} />
								{elseif $control->type == 2}
									<textarea cols="55" rows="10" name="{$control->name}">{$control->value}</textarea>
								{elseif $control->type == 3}

									{if $control->name == 'rating'}
										<div class="tpl-stars">
											<span></span>
											<span></span>
											<span></span>
											<span></span>
											<span></span>
											<input name="{$control->name}" type="hidden" value="0" />
										</div>
									{else}
										<ul>
											{foreach from=$control->options item=e}
												<li><label><input type="radio" name="{$control->name}" value="{$e.0}"> {$e.1}</label></li>
											{/foreach}
										</ul>
									{/if}

								{elseif $control->type == 12}
									<input type="password" size="{$control->params.size}" name="{$control->name}" {if $control->params.maxlength}maxlength="{$control->params.maxlength}"{/if} {if $control->value}value="{$control->value}"{/if} />
								{/if}
							</div>

							{if $control->note}
								<div class="tpl-note">{$control->note}</div>
							{/if}

						</div>
					{/if}
				{/foreach}

				<div class="tpl-field">
					<input type="submit" class="tpl-button tpl-button-big" value="{#SHOP2_SEND2#}" />
				</div>

			</form>
		{/if}

	{else}

		{if $user_settings.link}
			{*<div class="tpl-block-header">{#SHOP2_SIGN_IN_LEAVE_COMMENT#}</div>*}	
			{include file="global:shop2.v2-authorization.tpl"}
			{if $user_settings.social_params}
			<div class="shop2v2-cart-soc-block">
				{include file="global:block.g-social.tpl"}
			</div>
		{/if}
		{/if}

	{/if}
{/if}
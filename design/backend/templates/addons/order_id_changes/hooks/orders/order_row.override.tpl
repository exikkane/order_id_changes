<tr class="cm-longtap-target"
    data-ca-longtap-action="setCheckBox"
    data-ca-longtap-target="input.cm-item"
    data-ca-id="{$o.order_id}"
>
    <td width="3%" class="left mobile-hide table__check-items-cell table__check-items-cell--show-checkbox">
        <input type="checkbox" name="order_ids[]" value="{$o.order_id}" class="cm-item cm-item-status-{$o.status|lower}" /></td>
    <td width="15%" data-th="{__("id")}">
        <a href="{"orders.details?order_id=`$o.order_id`"|fn_url}" class="underlined link--monochrome">{__("order")} <bdi>#{if $o.alternative_id}{$o.alternative_id}{else}{$o.order_id}{/if}</bdi></a>
        {if $order_statuses[$o.status].params.appearance_type == "I" && $o.invoice_id}
            <p class="muted">{__("invoice")} #{$o.invoice_id}</p>
        {elseif $order_statuses[$o.status].params.appearance_type == "C" && $o.credit_memo_id}
            <p class="muted">{__("credit_memo")} #{$o.credit_memo_id}</p>
        {/if}
        {include file="views/companies/components/company_name.tpl" object=$o}
    </td>
    <td width="15%" data-th="{__("status")}">
        {include file="common/select_popup.tpl"
        type="orders"
        suffix="o"
        order_info=$o
        id=$o.order_id
        status=$o.status
        items_status=$order_status_descr
        update_controller="orders"
        notify=$notify
        notify_department=$notify_department
        notify_vendor=$notify_vendor
        status_target_id="orders_total,`$rev`"
        extra="&return_url=`$extra_status`"
        statuses=$order_statuses
        btn_meta="btn btn-info o-status-`$o.status` order-status"|lower
        text_wrap=true
        }
        {if $o.issuer_id}
            {if $o.issuer_name|trim}
                <p class="muted shift-left manager-order">{$o.issuer_name}</p>
            {else}
                <p class="muted shift-left manager-order">{$o.issuer_email}</p>
            {/if}
        {/if}
    </td>
    <td width="15%" class="nowrap" data-th="{__("date")}">{$o.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
    <td width="17%" data-th="{__("customer")}">
        {if $o.email}<a href="mailto:{$o.email|escape:url}" class="link--monochrome">@</a> {/if}
        {if $o.company}<p class="muted">{$o.company}</p>{/if}
        {if $o.user_type !== "UserTypes::CUSTOMER"|enum
        && $auth.user_type !== "UserTypes::ADMIN"|enum
        && $o.user_id !== $auth.user_id
        || !$o.user_id
        }
            {$o.lastname} {$o.firstname}
        {elseif $o.user_id}
            <a href="{"profiles.update?user_id=`$o.user_id`"|fn_url}" class="link--monochrome">{$o.lastname} {$o.firstname}</a>
        {/if}
    </td>
    <td width="14%" {if $o.phone}data-th="{__("phone")}"{/if}>{if $o.phone}<bdi><a href="tel:{$o.phone}" class="link--monochrome">{$o.phone}</a></bdi>{/if}</td>

    {hook name="orders:manage_data"}{/hook}

    <td class="center" data-th="{__("tools")}">
        {capture name="tools_items"}
            <li>{btn type="list" href="orders.details?order_id=`$o.order_id`" text={__("view")}}</li>
            {hook name="orders:list_extra_links"}
                <li>{btn type="list" href="order_management.edit?order_id=`$o.order_id`" text={__("edit")}}</li>
                <li>{btn type="list" href="order_management.edit?order_id=`$o.order_id`&copy=1" text={__("copy")}}</li>
            {$current_redirect_url=$config.current_url|escape:url}
                <li>{btn type="list" href="orders.delete?order_id=`$o.order_id`&redirect_url=`$current_redirect_url`" class="cm-confirm" text={__("delete")} method="POST"}</li>
            {/hook}
        {/capture}
        <div class="hidden-tools">
            {dropdown content=$smarty.capture.tools_items}
        </div>
    </td>
    <td width="10%" class="right" data-th="{__("total")}">
        {include file="common/price.tpl" value=$o.total}
    </td>
</tr>
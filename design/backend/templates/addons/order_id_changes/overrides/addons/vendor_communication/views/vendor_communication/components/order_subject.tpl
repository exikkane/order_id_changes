{*
    $order array Order data
*}

<a href="{"orders.details?order_id=`$order.order_id`"|fn_url}">
    <small>
        {__("order")} #{if $order.alternative_id}{$order.alternative_id}{else}{$order.order_id}{/if}, {include file="common/price.tpl" value=$order.total}
    </small>
</a>

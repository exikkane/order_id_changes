<?php

function fn_order_id_changes_create_order(&$order)
{
    $order['alternative_id'] = fn_order_id_changes_generate_alternative_id();
}

function fn_order_id_changes_generate_alternative_id(): string
{
    $first_number = rand(100, 999);
    $second_number = rand(1000000, 9999999);
    $third_number = rand(100000000, 999999999);

    $formatted_number = "{$first_number}-{$second_number}-{$third_number}";

    return $formatted_number;
}
function fn_order_id_changes_get_orders($params, &$fields, $sortings, $condition, $join, $group)
{
    $fields[] = '?:orders.alternative_id';
}
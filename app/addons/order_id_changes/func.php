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
function fn_order_id_changes_get_orders($params, &$fields, $sortings, &$condition, $join, $group)
{
    $fields[] = '?:orders.alternative_id';

    if (!empty($params['order_id'])) {
        $condition .= db_quote(' OR ?:orders.alternative_id = ?s', $params['order_id']);
    }
}

function fn_order_id_changes_get_shipments($params, &$fields_list, $joins, $condition, $group)
{
    $fields_list[] = '?:orders.alternative_id';
}

function fn_order_id_changes_vendor_communication_get_object_data($object_id, $object_type, &$object)
{
    if ($object_type === VC_OBJECT_TYPE_ORDER) {
        $alternative_id = db_get_field("SELECT alternative_id FROM ?:orders WHERE order_id = ?i", $object_id);

        $object['alternative_id'] = $alternative_id;
    }
}

function fn_order_id_changes_do_call_request(&$params, $product_data, $cart, $auth, $company_id)
{
    if (!empty($params['order_id'])) {
        $alternative_id = db_get_field("SELECT alternative_id FROM ?:orders WHERE order_id = ?i", $params['order_id']);

        $params['order_id'] = $alternative_id;
    }
}

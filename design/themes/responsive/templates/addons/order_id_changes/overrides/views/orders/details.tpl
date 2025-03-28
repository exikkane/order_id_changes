<div class="ty-orders-detail">

    {if $order_info}

        {capture name="order_actions"}
            {if $view_only != "Y"}
                <div class="ty-orders__actions">
                    {hook name="orders:details_tools"}
                    {$print_order = __("print_invoice")}
                    {if $status_settings.appearance_type == "C" && $order_info.doc_ids[$status_settings.appearance_type]}
                        {$print_order = __("print_credit_memo")}
                    {elseif $status_settings.appearance_type == "O"}
                        {$print_order = __("print_order_details")}
                    {/if}

                        {include file="buttons/button.tpl" but_role="text" but_text=$print_order but_href="orders.print_invoice?order_id=`$order_info.order_id`" but_meta="cm-new-window ty-btn__text" but_icon="ty-icon-print orders-print__icon"}
                    {/hook}

                    <div class="ty-orders__actions-right">
                        {if $view_only != "Y"}
                            {hook name="orders:details_bullets"}
                            {/hook}
                        {/if}

                        {include file="buttons/button.tpl" but_meta="ty-btn__text" but_role="text" but_text=__("re_order") but_href="orders.reorder?order_id=`$order_info.order_id`" but_icon="ty-orders__actions-icon ty-icon-cw"}
                    </div>

                </div>
            {/if}
        {/capture}

        {capture name="tabsbox"}

            <div id="content_general" class="{if $selected_section && $selected_section != "general"}hidden{/if}">

                {if $without_customer != "Y"}
                    {* Customer info *}
                    <div class="orders-customer">
                        {include file="views/profiles/components/profiles_info.tpl" user_data=$order_info location="I"}
                    </div>
                    {* /Customer info *}
                {/if}


                {capture name="group"}

                    {include file="common/subheader.tpl" title=__("products_information")}

                    <table class="ty-orders-detail__table ty-table">
                        {hook name="orders:items_list_header"}
                            <thead>
                            <tr>
                                <th class="ty-orders-detail__table-product">{__("product")}</th>
                                <th class="ty-orders-detail__table-price">{__("price")}</th>
                                <th class="ty-orders-detail__table-quantity">{__("quantity")}</th>
                                {if $order_info.use_discount}
                                    <th class="ty-orders-detail__table-discount">{__("discount")}</th>
                                {/if}
                                {if $order_info.taxes && $settings.Checkout.tax_calculation != "subtotal"}
                                    <th class="ty-orders-detail__table-tax">{__("tax")}</th>
                                {/if}
                                <th class="ty-orders-detail__table-subtotal">{__("subtotal")}</th>
                            </tr>
                            </thead>
                        {/hook}
                        {foreach from=$order_info.products item="product" key="key"}
                            {hook name="orders:items_list_row"}
                            {if !$product.extra.parent}
                                <tr class="ty-valign-top">
                                    <td>
                                        <div class="clearfix">
                                            <div class="ty-float-left ty-orders-detail__table-image">
                                                {hook name="orders:product_icon"}
                                                {if $product.is_accessible}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{/if}
                                                    {include file="common/image.tpl" obj_id=$key images=$product.main_pair image_width=$settings.Thumbnails.product_cart_thumbnail_width image_height=$settings.Thumbnails.product_cart_thumbnail_height}
                                                {if $product.is_accessible}</a>{/if}
                                                {/hook}
                                            </div>

                                            <div class="ty-overflow-hidden ty-orders-detail__table-description-wrapper">
                                                <div class="ty-ml-s ty-orders-detail__table-description">
                                                    {if $product.is_accessible}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{/if}
                                                        {$product.product nofilter}
                                                        {if $product.is_accessible}</a>{/if}
                                                    {if $product.extra.is_edp == "Y"}
                                                        <div class="ty-right">
                                                            <a href="{"orders.order_downloads?order_id=`$order_info.order_id`"|fn_url}">[{__("download")}]</a>
                                                        </div>
                                                    {/if}
                                                    {if $product.product_code}
                                                        <div class="ty-orders-detail__table-code">{__("sku")}:&nbsp;{$product.product_code}</div>
                                                    {/if}
                                                    {hook name="orders:product_info"}
                                                    {if $product.product_options}{include file="common/options_info.tpl" product_options=$product.product_options inline_option=true}{/if}
                                                    {/hook}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="ty-right">
                                        {if $product.extra.exclude_from_calculate}{__("free")}{else}{include file="common/price.tpl" value=$product.original_price}{/if}
                                    </td>
                                    <td class="ty-center">&nbsp;{$product.amount}</td>
                                    {if $order_info.use_discount}
                                        <td class="ty-right">
                                            {if $product.extra.discount|floatval}{include file="common/price.tpl" value=$product.extra.discount}{else}-{/if}
                                        </td>
                                    {/if}
                                    {if $order_info.taxes && $settings.Checkout.tax_calculation != "subtotal"}
                                        <td class="ty-center">
                                            {if $product.tax_value|floatval}{include file="common/price.tpl" value=$product.tax_value}{else}-{/if}
                                        </td>
                                    {/if}
                                    <td class="ty-right">
                                        &nbsp;{if $product.extra.exclude_from_calculate}{__("free")}{else}{include file="common/price.tpl" value=$product.display_subtotal}{/if}
                                    </td>
                                </tr>
                            {/if}
                            {/hook}
                        {/foreach}

                        {hook name="orders:extra_list"}
                        {assign var="colsp" value=5}
                        {if $order_info.use_discount}{assign var="colsp" value=$colsp+1}{/if}
                        {if $order_info.taxes && $settings.Checkout.tax_calculation != "subtotal"}{assign var="colsp" value=$colsp+1}{/if}
                        {/hook}

                    </table>

                    {*Customer notes*}
                    {if $order_info.notes}
                        <div class="ty-orders-notes">
                            {include file="common/subheader.tpl" title=__("customer_notes")}
                            <div class="ty-orders-notes__body">
                                <span class="ty-caret"><span class="ty-caret-outer"></span><span class="ty-caret-inner"></span></span>
                                {$order_info.notes|nl2br nofilter}
                            </div>
                        </div>
                    {/if}
                    {*/Customer notes*}

                    <div class="ty-orders-summary clearfix">
                        {include file="common/subheader.tpl" title=__("summary")}

                        <div class="ty-orders-summary__right">
                            {hook name="orders:info"}{/hook}
                        </div>

                        <div class="ty-orders-summary__wrapper">
                            <table class="ty-orders-summary__table">
                                {hook name="orders:totals"}
                                {if $order_info.payment_id}
                                    <tr class="ty-orders-summary__row">
                                        <td>{__("payment_method")}:</td>
                                        <td style="width: 57%" data-ct-orders-summary="summary-payment">
                                            {hook name="orders:totals_payment"}
                                            {$order_info.payment_method.payment} {if $order_info.payment_method.description}({$order_info.payment_method.description}){/if}
                                            {/hook}
                                        </td>
                                    </tr>
                                {/if}

                                {if $order_info.shipping}
                                    <tr class="ty-orders-summary__row">
                                        <td>{__("shipping_method")}:</td>
                                        <td data-ct-orders-summary="summary-ship">
                                            {hook name="orders:totals_shipping"}
                                            {if $use_shipments}
                                                <ul>
                                                    {foreach from=$order_info.shipping item="shipping_method"}
                                                        <li>{if $shipping_method.shipping} {$shipping_method.shipping} {else} – {/if}</li>
                                                    {/foreach}
                                                </ul>
                                            {else}
                                                {foreach from=$order_info.shipping item="shipping" name="f_shipp"}

                                                    {if $shipments[$shipping.group_key].carrier_info.tracking_url && $shipments[$shipping.group_key].tracking_number}
                                                        {$shipping.shipping}&nbsp;({__("tracking_number")}: <a target="_blank" href="{$shipments[$shipping.group_key].carrier_info.tracking_url nofilter}">{$shipments[$shipping.group_key].tracking_number}</a>)
                                                        {$shipment.carrier_info.info nofilter}
                                                    {elseif $shipments[$shipping.group_key].tracking_number}
                                                        {$shipping.shipping}&nbsp;({__("tracking_number")}: {$shipments[$shipping.group_key].tracking_number})
                                                        {$shipment.carrier_info.info nofilter}
                                                    {elseif $shipments[$shipping.group_key].carrier}
                                                        {$shipping.shipping}&nbsp;({__("carrier")}: {$shipments[$shipping.group_key].carrier_info.name nofilter})
                                                        {$shipment.carrier_info.info nofilter}
                                                    {else}
                                                        {$shipping.shipping}
                                                    {/if}
                                                    {if !$smarty.foreach.f_shipp.last}<br>{/if}
                                                {/foreach}
                                            {/if}
                                            {/hook}
                                        </td>
                                    </tr>
                                {/if}

                                    <tr class="ty-orders-summary__row">
                                        <td>{__("subtotal")}:&nbsp;</td>
                                        <td data-ct-orders-summary="summary-subtotal">{include file="common/price.tpl" value=$order_info.display_subtotal}</td>
                                    </tr>
                                {if $order_info.display_shipping_cost|floatval}
                                    <tr class="ty-orders-summary__row">
                                        <td>{__("shipping_cost")}:&nbsp;</td>
                                        <td data-ct-orders-summary="summary-shipcost">{include file="common/price.tpl" value=$order_info.display_shipping_cost}</td>
                                    </tr>
                                {/if}

                                {if $order_info.discount|floatval}
                                    <tr class="ty-orders-summary__row">
                                        <td class="ty-strong">{__("including_discount")}:</td>
                                        <td class="ty-nowrap" data-ct-orders-summary="summary-discount">
                                            {include file="common/price.tpl" value=$order_info.discount}
                                        </td>
                                    </tr>
                                {/if}

                                {if $order_info.subtotal_discount|floatval}
                                    <tr class="ty-orders-summary__row">
                                        <td class="ty-strong">{__("order_discount")}:</td>
                                        <td class="ty-nowrap" data-ct-orders-summary="summary-sub-discount">
                                            {include file="common/price.tpl" value=$order_info.subtotal_discount}
                                        </td>
                                    </tr>
                                {/if}

                                {if $order_info.coupons}
                                    {foreach from=$order_info.coupons item="coupon" key="key"}
                                        <tr class="ty-orders-summary__row">
                                            <td class="ty-nowrap">{__("coupon")}:</td>
                                            <td data-ct-orders-summary="summary-coupons">{$key}</td>
                                        </tr>
                                    {/foreach}
                                {/if}

                                {if $order_info.taxes}
                                    <tr class="taxes">
                                        <td><strong>{__("taxes")}:</strong></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    {foreach from=$order_info.taxes item=tax_data}
                                        <tr class="ty-orders-summary__row">
                                            <td class="ty-orders-summary__taxes-description">
                                                {$tax_data.description}
                                                {include file="common/modifier.tpl" mod_value=$tax_data.rate_value mod_type=$tax_data.rate_type}
                                                {if $tax_data.price_includes_tax == "Y" && ($settings.Appearance.cart_prices_w_taxes != "Y" || $settings.Checkout.tax_calculation == "subtotal")}
                                                    {__("included")}
                                                {/if}
                                                {if $tax_data.regnumber}
                                                    ({$tax_data.regnumber})
                                                {/if}
                                            </td>
                                            <td class="ty-orders-summary__taxes-description" data-ct-orders-summary="summary-tax-sub">{include file="common/price.tpl" value=$tax_data.tax_subtotal}</td>
                                        </tr>
                                    {/foreach}
                                {/if}
                                {if $order_info.tax_exempt == "Y"}
                                    <tr class="ty-orders-summary__row">
                                        <td>{__("tax_exempt")}</td>
                                        <td>&nbsp;</td>
                                    <tr>
                                {/if}

                                {if $order_info.payment_surcharge|floatval && !$take_surcharge_from_vendor}
                                    <tr class="ty-orders-summary__row">
                                        <td>{$order_info.payment_method.surcharge_title|default:__("payment_surcharge")}:&nbsp;</td>
                                        <td data-ct-orders-summary="summary-surchange">{include file="common/price.tpl" value=$order_info.payment_surcharge}</td>
                                    </tr>
                                {/if}
                                {hook name="orders:order_total"}
                                    <tr class="ty-orders-summary__row">
                                        <td class="ty-orders-summary__total">{__("total")}:&nbsp;</td>
                                        <td class="ty-orders-summary__total" data-ct-orders-summary="summary-total">{include file="common/price.tpl" value=$order_info.total}</td>
                                    </tr>
                                {/hook}
                                {/hook}
                            </table>
                        </div>
                    </div>

                    {if $order_info.promotions}
                        {include file="views/orders/components/promotions.tpl" promotions=$order_info.promotions}
                    {/if}

                    {if $view_only != "Y"}
                        <div class="ty-orders-repay litecheckout">
                            {hook name="orders:repay"}
                            {if $status_settings.repay == "YesNo::YES"|enum && $payment_methods}
                                {include file="views/orders/components/order_repay.tpl"}
                            {/if}
                            {/hook}
                        </div>
                    {/if}

                {/capture}
                <div class="ty-orders-detail__products orders-product">
                    {include file="common/group.tpl"  content=$smarty.capture.group}
                </div>
            </div><!-- main order info -->

            {if $use_shipments}
                <div id="content_shipment_info" class="ty-orders-shipment {if $selected_section != "shipment_info"}hidden{/if}">
                    {foreach $shipments as $shipment}
                        {include file="common/subheader.tpl" title="{__("shipment")} #`$shipment.shipment_id`"}
                        <div class="ty-orders-shipment__info">
                            {hook name="orders:shipment_info"}
                                <p>{$shipment.shipping}</p>
                            {if $shipment.carrier}
                                <p>{__("carrier")}: {$shipment.carrier_info.name nofilter}{if $shipment.tracking_number} ({__("tracking_number")}: {if $shipment.carrier_info.tracking_url}<a target="_blank" href="{$shipment.carrier_info.tracking_url nofilter}">{/if}{$shipment.tracking_number}{if $shipment.carrier_info.tracking_url}</a>{/if}){/if}</p>

                                {$shipment.carrier_info.info nofilter}
                            {/if}
                            {/hook}
                        </div>

                        <table class="ty-orders-shipment__table ty-table">
                            <thead>
                            <tr>
                                <th style="width: 90%">{__("product")}</th>
                                <th>{__("quantity")}</th>
                            </tr>
                            </thead>
                            {foreach from=$shipment.products key="product_hash" item="amount"}
                                {if $order_info.products.$product_hash}
                                    {assign var="product" value=$order_info.products.$product_hash}
                                    <tr style="vertical-align: top;">
                                        <td>{if $product.is_accessible}<a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="product-title">{/if}{$product.product nofilter}{if $product.is_accessible}</a>{/if}
                                            {if $product.extra.is_edp == "Y"}
                                                <div class="ty-right">
                                                    <a href="{"orders.order_downloads?order_id=`$order_info.order_id`"|fn_url}">[{__("download")}]</a>
                                                </div>
                                            {/if}
                                            {if $product.product_code}
                                                <p>{__("sku")}: {$product.product_code}</p>
                                            {/if}
                                            {if $product.product_options}{include file="common/options_info.tpl" product_options=$product.product_options inline_option=true}{/if}
                                        </td>
                                        <td class="ty-center">{$amount}</td>
                                    </tr>
                                {/if}
                            {/foreach}
                        </table>

                        {if $shipment.comments}
                            <div class="ty-orders-shipment-notes__info">
                                <h4 class="ty-orders-shipment-notes__header">{__("comments")}: </h4>
                                <div class="ty-orders-shipment-notes__body">
                                    <span class="caret"> <span class="ty-caret-outer"></span> <span class="ty-caret-inner"></span></span>
                                    {$shipment.comments}
                                </div>
                            </div>
                        {/if}

                        {foreachelse}
                        <p class="ty-no-items">{__("text_no_shipments_found")}</p>
                    {/foreach}
                </div>
            {/if}

            {hook name="orders:tabs"}
            {/hook}

        {/capture}
        {include file="common/tabsbox.tpl" top_order_actions=$smarty.capture.order_actions content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section}

    {/if}
</div>

{hook name="orders:details"}
{/hook}

{capture name="mainbox_title"}
    {__("order")}&nbsp;<bdi>{if $order_info.alternative_id}{$order_info.alternative_id}{else}{$order_info.order_id}{/if}</bdi>
    <em class="ty-date">({$order_info.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"})</em>
    <em class="ty-status">{__("status")}: {include file="common/status.tpl" status=$order_info.status display="view" name="update_order[status]"}</em>
{/capture}

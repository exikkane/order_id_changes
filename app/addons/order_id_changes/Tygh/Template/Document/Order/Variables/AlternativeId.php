<?php

namespace Tygh\Template\Document\Order\Variables;

class AlternativeId extends OrderVariable {

    /**
     * @inheritDoc
     */
    public static function attributes()
    {
        $attributes = parent::attributes();
        $attributes[] = 'alternative_id';
        return $attributes;
    }
}
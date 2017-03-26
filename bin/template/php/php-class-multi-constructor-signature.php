<?php

class A
{
	public function __construct() {
        $args = func_get_args();
        $argsStr = '';
        foreach ($args as $arg) {
            $argsStr .= '_' . gettype($arg);
        }
        if (method_exists($this, $constructor = '__construct' . $argsStr))
            call_user_func_array(array($this, $constructor), $args);
        else
            throw new Exception('NO CONSTRUCTOR: ' . get_class() . $constructor, NULL, NULL);
    }

	protected function __construct_integer($arg) {}
	protected function __construct_string($arg) {}
	protected function __construct_integer_string($arg, $barg) {}
	protected function __construct_string_integer($arg, $barg) {}
}


<?php

# Provides a __constructor supporting a variety of calling signatures
abstract class PolyConstructor
{
	public function __construct() {
        $args = func_get_args();
        $signature = join('_', array_map(
			function ($arg) { return gettype($arg); },
			$args));
		$constructor = "__construct_$signature";
        if (method_exists($this, $constructor))
		{
            call_user_func_array(array($this, $constructor), $args);
		}
        else
		{
			$class = get_class();
            throw new Exception(
				"Call to undefined constructor {$class}::$constructor",
				NULL, NULL);
		}
	}

	# Derived class should have constructor method like so:
	# protected function __construct_integer($int) {}
}


<?php

# Provides a __constructor supporting multiple arity signatures
abstract class ArityConstructor
{
	public function __construct ()
	{
		$args = func_get_args();
		$num_args = func_num_args();
		$constructor = "__construct$num_args";
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

	# Derived class should have constructor methods like so:
	# protected function __construct1 ($arg1) {}
	# protected function __construct2 ($arg1, $arg2) {}
}

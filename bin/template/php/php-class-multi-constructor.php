<?php
# Demonstration of a class with multiple constructors
class A
{
	protected function __construct1 ($arg1)
	{
		echo('__construct with 1 param called: ' . $arg1 . PHP_EOL);
	}

	protected function __construct2 ($arg1, $arg2)
	{
		echo('__construct with 2 params called: ' . $arg1 . ', ' . $arg2 . PHP_EOL);
	}

	protected function __construct3 ($arg1, $arg2, $arg3)
	{
		echo('__construct with 3 params called: ' . $arg1 . ', ' . $arg2 . ', ' . $arg3 . PHP_EOL);
	}

	public function __construct ()
	{
		$args = func_get_args();
		$num_args = func_num_args();
		$constructor = "__construct$num_args";
		if (method_exists($this, $constructor)) {
			call_user_func_array(array($this, $constructor), $args);
		}
	}

}

$o = new A('sheep');
$o = new A('sheep','cat');
$o = new A('sheep','cat','dog');

// results:
// __construct with 1 param called: sheep
// __construct with 2 params called: sheep,cat
// __construct with 3 params called: sheep,cat,dog


#!/usr/bin/env php
<?php
require_once('ClassPolyConstructor.php');
require_once('ClassArityConstructor.php');
require_once('ClassSingleton.php');
require_once('php-class.php');

const ¶ = PHP_EOL;

$user = new User('alice', 16);
$admin = new Admin('jaberwocky', 156, 'eating alice', 'scaly');

var_dump($user);

echo $user->Describe() . ¶;
echo $user->Penny4Thoughts() . ¶;
echo $user->Xray() . ¶;

# prohibited access to properties
#$user->thoughts;
#$user->junk;

# prohibited instantiate abstract class
#new Entity();

echo $admin->Describe() . ¶;
echo $admin->Penny4Thoughts() . ¶;
echo $admin->Xray() . ¶;

$admin->access();
var_dump($admin);

echo $admin->Describe() . ¶;
echo $admin->Penny4Thoughts() . ¶;
echo $admin->Xray() . ¶;

# prohibited inherit from a final class or override final method
#class God extends Admin {}
/*
class Psychic extends User
{
	public function Penny4Thoughts () {}
}
*/

# using PolyConstructor class

class Thing extends PolyConstructor
{
	protected function __construct_integer($int) {}
	protected function __construct_string($int) {}
	protected function __construct_integer_string($int, $str) {}
	protected function __construct_string_integer($str, $int) {}
}

$thing = new Thing(23);
var_dump($thing);
# no constructor with this signature...
#new Thing(12, 34);

# using ArityConstructor class

class Thung extends ArityConstructor
{
	protected function __construct1 ($arg1)
	{
		echo('__construct with 1 param called: ' . $arg1 . ¶);
	}

	protected function __construct2 ($arg1, $arg2)
	{
		echo('__construct with 2 params called: ' . $arg1 . ', ' . $arg2 . ¶);
	}

	protected function __construct3 ($arg1, $arg2, $arg3)
	{
		echo('__construct with 3 params called: ' . $arg1 . ', ' . $arg2 . ', ' . $arg3 . ¶);
	}
}

$o = new Thung('sheep');
$o2 = new Thung('sheep','cat');
$o3 = new Thung('sheep','cat','dog');

// results:
// __construct with 1 param called: sheep
// __construct with 2 params called: sheep,cat
// __construct with 3 params called: sheep,cat,dog

$s = Singleton::getInstance();
$t = Singleton::getInstance();
var_dump($s);

print "singleton compare: " . ($s === $t) . ¶;
print "non-singleton compare: " . ($o === $o2) . ¶;

echo ¶ . "end" . ¶ . ¶;

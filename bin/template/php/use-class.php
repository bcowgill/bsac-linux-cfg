#!/usr/bin/env php
<?php
require_once('php-class.php');

$user = new User('alice', 16);
$admin = new Admin('jaberwocky', 156, 'eating alice', 'scaly');

var_dump($user);

echo $user->Describe() . "\n";
echo $user->Penny4Thoughts() . "\n";
echo $user->Xray() . "\n";

# prohibited access to properties
#$user->thoughts;
#$user->junk;

# prohibited instantiate abstract class
#new Entity();

echo $admin->Describe() . "\n";
echo $admin->Penny4Thoughts() . "\n";
echo $admin->Xray() . "\n";

$admin->access();
var_dump($admin);

echo $admin->Describe() . "\n";
echo $admin->Penny4Thoughts() . "\n";
echo $admin->Xray() . "\n";

# prohibited inherit from a final class or override final method
#class God extends Admin {}
/*
class Psychic extends User
{
	public function Penny4Thoughts () {}
}
*/

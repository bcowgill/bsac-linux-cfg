#!/usr/bin/env php
<?php

require_once("functions.php");

$greeting = "Let's get to it!";
echo "Hello, World\n$greeting\n";

echo "\ndebugging ...\n";
var_dump($greeting);
echo 'gettype() ' . gettype($greeting) . "\n";
echo "var_dump(): ";
var_dump([$greeting]);
echo "print_r(): ";
print_r([$greeting]);
echo "\n";
echo "serialize() " . serialize([$greeting]) . "\n";

// type checking in code
echo "\nis_null() " . is_null($greeting) . "\n";
echo 'is_bool() ' . is_bool($greeting) . "\n";
echo 'is_int() ' . is_int($greeting) . "\n";
echo 'is_float() ' . is_float($greeting) . "\n";
echo 'is_string() ' . is_string($greeting) . "\n";
echo 'is_array() ' . is_array($greeting) . "\n";
echo 'is_object() ' . is_object($greeting) . "\n";
echo 'is_callable() ' . is_callable($greeting) . "\n";
echo 'is_resource() ' . is_resource($greeting) . "\n";
unset($greeting);
echo 'is_null() ' . is_null($greeting) . "\n";

echo "\nint sizes " . PHP_INT_SIZE . " " . PHP_INT_MIN . " " . PHP_INT_MAX . "\n";
var_dump(PHP_INT_MAX + 1);
var_dump(.123);

$ok = str_repeat('x', 2147483647);
echo "\nlength of string: " . strlen($ok) . "\n";
echo "substr from string: " . substr($ok, -5) . "\n";
$long = str_repeat('x', 2147483648);
echo "length of too big string: " . strlen($long) . "\n";
echo "substr from big string: " . substr($long, -5) . "\n";

echo "\n" . x('=', 76) . "\n";
echo to_hex_string(422342) . "\n";
echo to_octal_string(422342) . "\n";
echo to_bin_string(422342) . "\n";

setlocale(LC_ALL, 'en_GB.UTF-8');
echo "\nlocalconv()\n";
var_dump(localeconv());

echo "json_encode(): " . json_encode(localeconv(), JSON_PRETTY_PRINT) . "\n";
echo "serialize(): " . serialize(localeconv()) . "\n";

echo "\nnew generic objects: ";
echo json_encode([
	new stdClass(),  # cannot init any parameters
	#new class{},  php7
	(object)[ 'x' => 42, 'y' => -1 ],
	(object)NULL,
	(object)"convert string to object",
	(object)42,

], JSON_PRETTY_PRINT) . "\n";

$fp = fopen("php.php", "r");
echo "\nget_resource_type(): " . get_resource_type($fp) . "\n";


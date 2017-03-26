#!/usr/bin/env php
<?php
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

###########################################################################
function x($char, $repeat = 0) {
	if ($repeat > 0) {
		return sprintf("%'{$char}{$repeat}s","");
	}
	return '';
}
function pad_multiple($string, $multiple, $char = '0') {
	$length = $len = strlen($string);
	$modulo = $len % $multiple;
	if ($modulo) {
		$length = $multiple - $modulo + $len;
	}
	return str_pad($string, $length, '0', STR_PAD_LEFT);
}
function to_hex_string($value) {
	return '0x' . pad_multiple(base_convert($value, 10, 16), 4);
}
function to_octal_string($value) {
	return '0' . pad_multiple(base_convert($value % 8, 10, 8), 3);
}
function to_bin_string($value) {
	return '0b' . pad_multiple(base_convert($value, 10, 2), 4);
}


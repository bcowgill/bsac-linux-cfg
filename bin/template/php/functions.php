<?php
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


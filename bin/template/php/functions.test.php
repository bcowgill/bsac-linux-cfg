<?php
# ./vendor/bin/phpunit --bootstrap functions.php functions.test.php

# https://phpunit.de/manual/current/en/writing-tests-for-phpunit.html
# https://phpunit.de/manual/current/en/appendixes.assertions.html

# list all assert methods installed:
# perl -ne 's{\b((assert|expect)[A-Z]\w*)\(}{print "$1\n"}xmsge' `find vendor/phpunit/ -type f` | sort | uniq

use PHPUnit\Framework\TestCase;

/**
 * @covers functions
 */
final class FunctionsTest extends TestCase
{
	public function testFunctionXRepeatDefaultZero()
	{
		$this->assertSame(
			'',
			x('=')
		);
	}

	public function testFunctionXRepeatValue()
	{
		$this->assertSame(
			'=====',
			x('=', 5)
		);
	}

	public function testFunctionPadMultipleDefaultPadZero()
	{
		$this->assertSame(
			'0012',
			pad_multiple('12', 4)
		);
	}

	public function testFunctionPadMultipleNoRemainder()
	{
		$this->assertSame(
			'1212',
			pad_multiple('1212', 4)
		);
	}

	public function testFunctionPadMultipleTooLong()
	{
		$this->assertSame(
			'00121212',
			pad_multiple('121212', 4)
		);
	}

	public function testFunctionPadMultipleCustomChar()
	{
		$this->assertSame(
			'**12',
			pad_multiple('12', 4, '*')
		);
	}

	public function testToHexString()
	{
		$this->assertSame(
			'0x002d',
			to_hex_string(45)
		);
	}

	public function testToOctalString()
	{
		$this->assertSame(
			'0312',
			to_octal_string(202)
		);
	}

	public function testToOctalStringTooBig()
	{
		$this->assertSame(
			'0171064',
			to_octal_string(0xf234)
		);
	}
}

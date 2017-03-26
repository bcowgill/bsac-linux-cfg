<?php

abstract class Entity
{
	private static $next_id = 0;
	private $ident;

	public function __construct ()
	{
		echo "\nnew Entity " . self::$next_id . "\n";
		$this->ident = self::$next_id++;
	}

	public function __destruct ()
	{
		echo "\ndestruct Entity " . $this->ident . " " . self::$next_id . "\n";
	}

	final public function id ()
	{
		return $this->ident;
	}

	abstract public function powers ();
}

class User extends Entity
{
	public $name;
	public $age;
    protected $junk;
	private $thoughts;

	const TYPE = 'User';
	public static function type () { return self::TYPE; }

	# The class constructor function
	public function __construct ($name, $age, $thoughts = 'sex', $junk = 'sweet')
	{
		parent::__construct();
		$this->name = $name;
		$this->age = $age;
		$this->thoughts = $thoughts;
		$this->junk = $junk;
		# to ensure __destruct called on fatal error
		register_shutdown_function(array($this, '__destruct'));
	}

	# The class destructor function
	public function __destruct ()
	{
		echo $this->name . " is dead at the age of " . $this->age . ", what a tragedy.\n";
		parent::__destruct();
	}

	public function Describe ()
	{
		return $this->id() . ":" . $this->type() . ": " . $this->name . " is " . $this->age . " years old and has " . $this->powers() . " powers.";
	}

	final public function Penny4Thoughts ()
	{
		return $this->name . " is thinking about " . $this->thoughts . ".";
	}

	public function Xray ()
	{
		return $this->name . " has " . $this->junk . " junk.";
	}

	public function powers ()
	{
		return 'ordinary';
	}
}

final class Admin extends User
{
	const TYPE = 'Admin';
	public static function type () { return self::TYPE; }

	public function powers ()
	{
		return 'godlike';
	}

	public function access ()
	{
		$this->age = 234; # change a public value
		$this->junk = 'foul'; # change a protected value
		$this->thoughts = 'sleeping'; # does not modify User thoughts or cause error!!
	}
}

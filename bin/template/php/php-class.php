<?php
/**
* an Example/Template for a class in PHP
*
* @author Brent S.A. Cowgill
*/
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

	/**
	* answers with the unique id number of the Entity instance
	* @return integer the unique id number of the Entity instance
	*/
	final public function id ()
	{
		return $this->ident;
	}

	/**
	* answers with the powers assigned to the Entity
	* @return string describing what powers the Entity has
	*/
	abstract public function powers ();
}

class User extends Entity
{
	public $name;
	public $age;
    protected $junk;
	private $thoughts;

	const TYPE = 'User';

	/**
	* answers with the Entity class name
	* @return string name of Entity class type
	*/
	public static function type () { return self::TYPE; }

	/**
	* Construct a new ordinary User object.
	* @param string login name of the user.
	* @param integer age of the user in years.
	* @param string optional initial thoughts of the user.
	* @param string optional initial state of users's junk.
	*/
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

	/**
	* answers with a description of the User in plain text.
	* @return string description of the User in plain text.
	*/
	public function Describe ()
	{
		return $this->id() . ":" . $this->type() . ": " . $this->name . " is " . $this->age . " years old and has " . $this->powers() . " powers.";
	}

	/**
	* answers with users explanation of their private thoughts.
	* @return string users explanation of their private thoughts.
	*/
	final public function Penny4Thoughts ()
	{
		return $this->name . " is thinking about " . $this->thoughts . ".";
	}

	/**
	* answers with xray view of the user's junk.
	* @return string xray view of the user's junk.
	*/
	public function Xray ()
	{
		return $this->name . " has " . $this->junk . " junk.";
	}

	/**
	* implements base class powers method
	* @return string explanation of User's powers
	*/
	public function powers ()
	{
		return 'ordinary';
	}
}

final class Admin extends User
{
	const TYPE = 'Admin';

	/**
	* answers with the Entity class name
	* @return string name of Entity class type
	*/
	public static function type () { return self::TYPE; }

	/**
	* implements base class powers method
	* @return string explanation of User's powers
	*/
	public function powers ()
	{
		return 'godlike';
	}

	/**
	* checks access to public, protected, private values
	*/
	public function access ()
	{
		$this->age = 234; # change a public value
		$this->junk = 'foul'; # change a protected value
		$this->thoughts = 'sleeping'; # does not modify User thoughts or cause error!!
	}
}

<?php

/**
	A template class for a Singleton
*/
class Singleton
{
	// cached instance
	private static $instance = NULL;

	/**
		Prevent an object from being constructed.
	*/
	private function __construct () {}

	/**
		Function to return the instance of this class.
	*/
	public static function getInstance ()
	{
		if (is_null(self::$instance))
		{
			self::$instance = new Singleton();
		}
		return self::$instance;
	}
}

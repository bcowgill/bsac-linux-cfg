#!/usr/bin/env elixir
defmodule Guess
do
  @moduledoc """
  Plays the guess my secret number game.

  Guess.within will play the game given the actual number and the range of values.

  Guess.secret_number will create a number guessing function which responds with :low, :high or :true based on the guess value related to the secret number.

  Guess.my_number will play the game using a given number guessing function.
  """

  # Done like a function that knows it all...
  def within(actual, range \\ 1..1000)

  def within(actual, actual..actual)
  do
    IO.puts(actual)
    :true
  end

  def within(actual, min..max) when min <= actual and actual <= max
  do
    guess = div(min + max, 2)
    IO.puts("Is it #{guess}? [#{min},#{max}]")
    ((guess > actual) && within(actual, min..(guess-1)))
      || ((guess < actual) && within(actual, (guess+1)..max))
      || within(guess, guess..guess)
  end

  # Make the function which guards the (random) secret number
  def secret_number(secret \\ :rand.uniform(1000))
  do
    fn ^secret -> :true
      guess when (guess > secret) -> :high
      guess when (guess < secret) -> :low
    end
  end

  # Guess the number like a game using the secret number function
  def my_number(is_it_this, range \\ 1..1000)

  def my_number(is_it_this, min..max) when min <= max
  do
    make_guess(is_it_this, div(min + max, 2), min..max)
  end

  # private functions here on down...
  defp make_guess(is_it_this, guess, min..max)
  do
    next_guess(is_it_this.(guess), is_it_this, guess, min..max)
  end

  defp next_guess(:true, _, guess, _)
  do
    IO.puts("Is it #{guess}? yes!\n#{guess}")
  end

  defp next_guess(:low, is_it_this, guess, _..max)
  do
    IO.puts("Is it #{guess}? too low.")
    my_number(is_it_this, (guess + 1) .. max)
  end

  defp next_guess(:high, is_it_this, guess, min.._)
  do
    IO.puts("Is it #{guess}? too high.")
    my_number(is_it_this, min .. (guess - 1))
  end
end

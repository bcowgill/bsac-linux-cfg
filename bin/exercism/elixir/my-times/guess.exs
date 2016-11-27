#!/usr/bin/env elixir
defmodule Guess
do
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
end

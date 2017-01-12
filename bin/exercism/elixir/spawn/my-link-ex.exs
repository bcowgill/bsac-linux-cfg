#!/usr/local/bin/elixir -r
defmodule MyLinkEx do
  import :timer, only: [ sleep: 1 ]

  def greet(parent) do
    IO.puts "child #{inspect self} #{inspect parent}"
    send parent, :greetings
    raise RuntimeError, message: "greet error"
    exit(:out)
  end

  def listen do
    receive do
      msg ->
        IO.puts "MESSAGE RECEIVED: #{inspect msg}"
    	listen
      after 1000 ->
        IO.puts "THAT IS ALL"
    end
  end

  def run do
    IO.puts "me #{inspect self}"
    spawn_link(MyLinkEx, :greet, [self])
	sleep 500
	MyLinkEx.listen
  end
end

MyLinkEx.run

#!/usr/local/bin/elixir -r
# ./tickerd.exs --name tickerd@docuzilla.workshare.com
Code.load_file("ticker.ex", __DIR__)
IO.inspect Node.self
IO.puts inspect Ticker.start
:timer.sleep 4000
IO.puts "wake up"
IO.puts inspect Node.connect :"tickerc@docuzilla.workshare.com"
IO.puts inspect TickerClient.start
:timer.sleep 40000

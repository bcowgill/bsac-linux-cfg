#!/usr/local/bin/elixir -r
# ./tickerd_sequential.exs --name tickerd@docuzilla.workshare.com
Code.load_file("ticker_sequential.ex", __DIR__)
IO.inspect Node.self
IO.puts inspect Ticker.start
:timer.sleep 5000
IO.puts "wake up"
IO.puts inspect Node.connect :"tickerc@docuzilla.workshare.com"
IO.puts inspect Node.connect :"tickerc2@docuzilla.workshare.com"
IO.puts inspect Node.connect :"tickerc3@docuzilla.workshare.com"
IO.puts inspect TickerClient.start
:timer.sleep 40000

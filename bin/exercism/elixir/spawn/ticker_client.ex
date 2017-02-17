defmodule TickerClient do
  @name :ticker

  def name do
    @name
  end

  def start do
    pid = spawn(__MODULE__, :receiver, [])
	IO.puts "whereis #{@name}"
    send :global.whereis_name(@name), { :register, pid }
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client #{inspect self}"
        receiver
    end
  end
end

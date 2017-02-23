defmodule TickerRingClient do
  import :timer, only: [ sleep: 1 ]
  @name :tickerRing
  @interval 2000   # 2 seconds

  def name do
    @name
  end

  def interval do
    @interval
  end

  def start do
    pid = spawn(__MODULE__, :receiver, [])
	IO.puts "whereis #{@name}"
    send :global.whereis_name(@name), { :register, pid }
  end

  def receiver do
    receive do
      { :tick, [ next_pid | downstream ] } ->
        IO.puts "tock in client #{inspect self}"
		if next_pid do
		  sleep(@interval)
          IO.puts "send tick to next client #{inspect next_pid} ring: #{inspect downstream}"
		  send next_pid, { :tick, downstream }
		end
        receiver
    end
  end
end

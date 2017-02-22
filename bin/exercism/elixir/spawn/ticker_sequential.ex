Code.load_file("ticker_client.ex", __DIR__)

defmodule Ticker do

  @interval 2000   # 2 seconds

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    IO.puts "register #{TickerClient.name}"
    :global.register_name(TickerClient.name, pid)
  end

  def generator(clients_queue) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([ pid | clients_queue ])
    after
      @interval ->
        IO.puts "tick #{:os.system_time(:seconds)}"
		{ client, clients_waiting } = pop(clients_queue)
		case client do
		  nil ->
		    generator(clients_waiting)
		  client_pid ->
            send client_pid, { :tick }
            generator([ client_pid | clients_waiting ])
		end
    end
  end

  defp pop(list \\ [])
  defp pop([]) do
    { nil, [] }
  end
  defp pop(list) do
    last = List.last(list)
    remainder = Enum.slice(list, 0, length(list) - 1)
    { last, remainder }
  end
end

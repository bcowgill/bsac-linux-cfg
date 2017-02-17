Code.load_file("ticker_client.ex", __DIR__)

defmodule Ticker do

  @interval 2000   # 2 seconds

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    IO.puts "register #{TickerClient.name}"
    :global.register_name(TickerClient.name, pid)
  end

  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([pid|clients])
    after
      @interval ->
        IO.puts "tick #{:os.system_time(:seconds)}"
        Enum.each clients, fn client ->
          send client, { :tick }
        end
        generator(clients)
    end
  end
end

Code.load_file("ticker_ring_client.ex", __DIR__)

defmodule TickerRing do
  @interval TickerRingClient.interval

  def start do
    pid = spawn(__MODULE__, :generator, [[],[], nil])
    IO.puts "register #{TickerRingClient.name}"
    :global.register_name(TickerRingClient.name, pid)
  end

  def generator(clients_queue, new_clients_queue, tick_sent) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(clients_queue, [ pid | new_clients_queue ], tick_sent)
      { :tick, _ } ->
        IO.puts "tick from client"
        combined_queue = List.flatten(new_clients_queue, clients_queue)
        generator(combined_queue, [], nil)
    after
      @interval ->
        combined_queue = List.flatten(new_clients_queue, clients_queue)
        IO.puts "tick #{:os.system_time(:seconds)} #{inspect combined_queue}"
        cond do
          length(combined_queue) == 0 ->
            generator(clients_queue, new_clients_queue, nil)
          tick_sent ->
            generator(combined_queue, [], tick_sent)
          :otherwise ->
            sendTick(combined_queue)
            generator(combined_queue, [], :true)
        end
    end
  end

  defp sendTick([ pid | clients_queue ]) do
    ring_queue = List.insert_at(clients_queue, length(clients_queue), self)
    IO.puts "send tick to first client #{inspect pid} ring: #{inspect ring_queue}"
    send pid, { :tick, ring_queue }
  end

end

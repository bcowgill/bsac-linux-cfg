Code.load_file("retry.ex", __DIR__)

defmodule TickerRingClient do
  import :timer, only: [ sleep: 1 ]

  @name :tickerRing
  @interval_ms 5000   # millsecs

  # keep trying to start the client if the server not there yet.
  # returns client pid if succesfully started
  # returns nil if unable to start after num_tries counter counts down.
  def ensure_start(retry_delay_ms \\ 100, num_tries \\ :infinite) do
    Retry.until(fn (_, _) ->
        server = start()
        IO.puts "whereis #{@name} #{inspect server}"
        server
      end, retry_delay_ms, num_tries)
  end

  # start the client registered with the server or return nil
  def start do
    server = :global.whereis_name(@name)
    client_pid =
      case server do
        :undefined -> nil
        _ ->
          pid = spawn(__MODULE__, :receiver, [])
          send server, { :register, pid }
      end
    if client_pid do
      IO.puts "start client #{inspect client_pid} server #{inspect server}"
    end
    client_pid
  end

  # receive a :tick from the server and pass it to next client
  def receiver do
    receive do
      { :tick, [ next_pid | downstream ] } ->
        IO.puts "tock in client #{inspect self}"
        if next_pid do
          sleep(@interval_ms)
          IO.puts "send tick to next client #{inspect next_pid} ring: #{inspect downstream}"
          send next_pid, { :tick, downstream }
        end
        receiver
    end
  end

  def name do
    @name
  end

  def interval do
    @interval_ms
  end

end

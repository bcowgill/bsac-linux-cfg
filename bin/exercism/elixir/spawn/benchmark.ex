#!/usr/local/bin/elixir -r
defmodule Benchmark do
  @microsec 1000000.0

  def time_this(_name, func) do
    {time, result} = :timer.tc(func)
    #IO.puts "#{time / @microsec} s #{name}"
    {time, result}
  end

  def time_this(name, func, loops) do
    {time, result} = time_this(name, fn -> 1 .. loops |> Enum.each(fn _ -> func.() end) end)
    #IO.puts "#{loops * @microsec / time} calls/s #{name}"
    {time, result}
  end

  def benchmark(name, func, funcOverhead \\ nop, min_time_sec \\ 2) do
    {loops, result} = guess_loops(name, func, min_time_sec)
    {time, timeOverhead} = time_overhead(name, func, funcOverhead, loops)
    {time, timeOverhead, loops, result}
  end

  def time_these(testFuncs, funcOverhead \\ nop, min_time_sec \\ 2) do
    testFuncs
      |> Enum.map(fn {name, func} ->
          {time, timeOverhead, loops, _} = benchmark(name, func, funcOverhead, min_time_sec)
          actual = time - timeOverhead
          calls_per_sec = loops * @microsec / actual
          {name, actual, calls_per_sec, loops}
        end)
      |> Enum.sort(fn ({_,_,fast,_}, {_,_,slow,_}) -> fast >= slow end)
      |> Enum.each(fn {name, _actual, calls_per_sec, loops} ->
          IO.puts "#{calls_per_sec} calls/s #{name} w/o overhead (#{loops})"
        end)
  end

  defp time_overhead(name, func, funcOverhead, loops) do
    {time, _result} = time_this("#{name} x #{loops}", func, loops)
    {timeOverhead, _result} = time_this("#{name} overhead x #{loops}", funcOverhead, loops)
    cond do
      time < timeOverhead ->
        time_overhead(name, func, funcOverhead, loops)
      :otherwise -> {time, timeOverhead}
    end
  end

  defp guess_loops(name, func, min_time_sec, loops \\ 1) do
    {time, result} = time_this("guess #{name} x #{loops}", func, loops)
    new_loops = round(loops * min_time_sec * @microsec / time)
    {new_loops, result}
  end

  defp nop() do
    fn -> nil end
  end
end

IO.puts inspect Benchmark.time_these([
  sleep20: fn -> :timer.sleep(20) end,
  sleep10: fn -> :timer.sleep(10) end,
  sqrt: fn -> :math.sqrt(980345.7) end,
  pi: fn -> :math.pi end,
  add: fn -> 1 + 1 end
])

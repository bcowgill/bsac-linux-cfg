#!/usr/local/bin/elixir -r

Code.load_file("scheduler.exs", __DIR__)

defmodule FibSolver do

  def fib(scheduler) do
    Process.put(0, 0)
	Process.put(1, 1)
    do_fib(scheduler)
  end

  defp do_fib(scheduler) do
    send scheduler, { :ready, self }
    receive do
      { :fib, n, client } ->
        send client, { :answer, n, fib_calc(n), self }
        do_fib(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  defp fib_calc(n) do
    case Process.get(n) do
	  nil ->
        n_1 = fib_calc(n-1)
        result = n_1 + Process.get(n-2)
        Process.put(n, result)
	    result

      cached_value ->
        cached_value
    end
  end
end

to_process = List.duplicate(30000, 20)
#to_process = List.duplicate(40000, 20)
Scheduler.benchmark(10, FibSolver, :fib, to_process)

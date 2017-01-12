#!/usr/local/bin/elixir -r

Code.load_file("scheduler.exs", __DIR__)

defmodule FibSolver do

  def fib(scheduler) do
    send scheduler, { :ready, self }
    receive do
      { :fib, n, client } ->
        send client, { :answer, n, fib_calc(n), self }
        fib(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end
  # very inefficient, deliberately
  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n-1) + fib_calc(n-2)
end

to_process = List.duplicate(37, 20)
Scheduler.benchmark(10, FibSolver, :fib, to_process)

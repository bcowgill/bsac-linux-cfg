#!/usr/local/bin/elixir -r

Code.load_file("fib_agent.exs", __DIR__)
Code.load_file("scheduler.exs", __DIR__)

defmodule FibSolver do

  def fib(scheduler) do
    { :ok, agent } = FibAgent.start_link()
	do_fib(scheduler, agent)
  end

  defp do_fib(scheduler, agent) do
    send scheduler, { :ready, self }
    receive do
      { :fib, n, client } ->
        send client, { :answer, n, fib_calc(n, agent), self }
        do_fib(scheduler, agent)
      { :shutdown } ->
        exit(:normal)
    end
  end

  defp fib_calc(n, agent), do: FibAgent.fib(agent, n)
end

to_process = List.duplicate(30000, 20)
#to_process = List.duplicate(40000, 20)
Scheduler.benchmark(10, FibSolver, :fib, to_process)

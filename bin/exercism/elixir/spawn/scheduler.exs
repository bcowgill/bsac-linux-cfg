defmodule Scheduler do

  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
    |> schedule_processes(func, to_calculate, [])
  end

  def benchmark(max_processes, module, func, to_calculate) do
    Enum.each max_processes..1, fn num_processes ->
      {time, result} = :timer.tc(
        Scheduler, :run,
        [num_processes, module, func, to_calculate]
      )

      if num_processes == max_processes do
        IO.puts "#{module}.#{func} parallel calculator service"
        IO.puts "calculated results:"
        IO.puts inspect result
        IO.puts "procs\n #   time (s)"
      end
      :io.format "~2B     ~.2f~n", [num_processes, time/1000000.0]
    end
  end

  defp schedule_processes(processes, token, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {token, next, self}
        schedule_processes(processes, token, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), token, queue, results)
        else
          Enum.sort(results, fn {n1,_}, {n2,_}  -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, token, queue, [ {number, result} | results ])
    end
  end
end


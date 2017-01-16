#!/usr/local/bin/elixir -r

Code.load_file("scheduler.exs", __DIR__)

defmodule CatFinder do

  def cat(scheduler) do
    send scheduler, { :ready, self }
    receive do
      { :cat, file_name, client } ->
        send client, { :answer, file_name, cat_find(file_name), self }
        cat(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  defp cat_find(file_name) do
    length(Regex.scan(~r/\bcat\b/i, File.read!(file_name)))
  end
end

dir = "/home/me/bin/english/"

to_process = File.ls!(dir)
  |> Enum.map(fn file -> dir <> file end)
  |> Enum.filter(fn file -> ! File.dir? file end)
Scheduler.benchmark(10, CatFinder, :cat, to_process)

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

  def find_files(dir) do
    do_find_files(dir)
  end

  defp do_find_files(dir, result \\ [])

  defp do_find_files(dir, result) do
    found = File.ls!(dir)
	  |> Enum.map(fn file -> recurse(dir, file) end)
      |> Enum.filter(fn file -> ! File.dir? file end)

    List.flatten(result ++ found)
  end

  defp recurse(dir, file) do
    full = dir <> "/" <> file
    cond do
	  File.regular? full -> full
	  File.dir? full -> find_files(full)
	end
  end

  defp cat_find(file_name) do
    length(Regex.scan(~r/\bcat\b/i, File.read!(file_name)))
  end
end

dir = "/home/me/bin/english"

to_process = CatFinder.find_files(dir)
Scheduler.benchmark(10, CatFinder, :cat, to_process)

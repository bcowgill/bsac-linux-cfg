defmodule Menum do

  def all?(enumerable, func \\ &(&1)) when
    is_function(func) do
	do_all?(enumerable, func)
  end

  defp do_all?([ last | [] ], func) do
    !!func.(last)
  end

  defp do_all?(enumerable, func)
  do
    if func.(hd(enumerable)) do
	  do_all?(tl(enumerable), func)
	else
	  false
	end
  end

  def each(enumerable, func) when
    is_function(func) do
    do_each(enumerable, func)
  end

  defp do_each([], _), do: :ok

  defp do_each(enumerable, func) do
    func.(hd(enumerable))
	do_each(tl(enumerable), func)
  end
end

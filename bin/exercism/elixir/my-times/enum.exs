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
    func.(hd(enumerable)) and do_all?(tl(enumerable), func)
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

  def filter(enumerable, func \\ &(&1)) when
    is_function(func) do
    do_filter(enumerable, func)
  end

  defp do_filter([], _func), do: []

  defp do_filter(enumerable, func) do
    head = hd(enumerable)
    if func.(head) do
      [ head | do_filter(tl(enumerable), func) ]
    else
      do_filter(tl(enumerable), func)
    end
  end

  def split(enumerable, count) when
    is_integer(count) do
    do_split([], enumerable, count)
  end

  defp do_split(leading, [], _), do: {leading, []}
  defp do_split(leading, enumerable, 0), do: {leading, enumerable}

  defp do_split(leading, enumerable, count) when
    count >= 0 do
	do_split([ leading | hd(enumerable) ], tl(enumerable), count - 1)
  end

  defp do_split(leading, enumerable, count) when
    count < 0 do
    {}
  end

  def test() do
    list = [false, 1, nil, 3, 4, 5]
    IO.inspect(Enum.filter(list, &(&1)))
    IO.inspect(filter(list))

    IO.inspect(Enum.split([1, 2, 3], 2))
    IO.inspect(split([1, 2, 3], 2))

    IO.inspect(Enum.split([1, 2, 3], 10))
    IO.inspect(split([1, 2, 3], 10))

    IO.inspect(Enum.split([1, 2, 3], 0))
    IO.inspect(split([1, 2, 3], 0))

    IO.inspect(Enum.split([1, 2, 3], -1))
    IO.inspect(split([1, 2, 3], -1))

    IO.inspect(Enum.split([1, 2, 3], -5))
    IO.inspect(split([1, 2, 3], -5))

  end


end

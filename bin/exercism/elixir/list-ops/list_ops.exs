defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(list) when
    is_list(list) do
    reduce(list, 0, fn (_, sum) -> 1 + sum end)
  end

  @spec reverse(list) :: list
  def reverse(list) when
    is_list(list) do
    reduce(list, [], fn (item, reversed) -> append_any(item, reversed) end)
  end

  @spec map(list, (any -> any)) :: list
  def map(list, func) when
    is_list(list) and is_function(func) do
    for datum <- list do
      func.(datum)
    end
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(list, func \\ &(&1))

  def filter(list, func) when
    is_list(list) and is_function(func) do
    do_filter(list, func)
  end

  defp do_filter([], _func), do: []

  defp do_filter(list, func) do
    head = hd(list)
    if func.(head) do
      [ head | do_filter(tl(list), func) ]
    else
      do_filter(tl(list), func)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, _func), do: acc
  def reduce([ head | tail ], acc, func) when
    is_function(func) do
    reduce(tail, func.(head, acc), func)
  end

  @spec append(list, list) :: list
  def append(some, more) when
    is_list(some) and is_list(more) do
    append_any(some, more)
  end

  # MUSTDO implement without ++
  defp append_any(some, more), do: listify(some) ++ listify(more)

  defp listify(thing) when
    is_list(thing) do
    thing
  end

  defp listify(thing), do: [thing]

  @spec concat([[any]]) :: [any]
  def concat(list_of_lists) when
    is_list(list_of_lists) do
    # MUSTDO need a faster implementation...
    reduce(list_of_lists, [], fn (list, joined) -> append_any(joined, list) end)
  end
end

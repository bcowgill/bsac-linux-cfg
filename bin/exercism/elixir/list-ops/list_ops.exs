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
  def reverse(list) when is_list(list) do
    do_reverse(list)
  end

  defp do_reverse(list, into \\ [])
  defp do_reverse([], []), do: []
  defp do_reverse([], into), do: into
  defp do_reverse([head | tail], into), do: do_reverse(tail, [head | into])

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

  #@spec append_any(a | [a], b | [b]) :: [a, b]
  defp append_any(some, more) do
    some
    |> listify
    |> reverse
    |> prepend_reversed(listify(more))
    |> reverse
  end

  #@spec prepend_reversed([b, a], [c, d]) :: [d, c, b, a]
  defp prepend_reversed(list, prepend) when
    is_list(list) and is_list(prepend) do
    do_prepend_reversed(list, prepend)
  end

  defp do_prepend_reversed(list, []), do: list
  defp do_prepend_reversed(list, [ head | tail ]) do
    do_prepend_reversed([ head | list ], tail)
  end

  #@spec listify?(a | [a]) :: [a]
  defp listify(thing) when
    is_list(thing) do
    thing
  end

  defp listify(thing), do: [thing]

  @spec concat([[any]]) :: [any]
  def concat(list_of_lists) when
    is_list(list_of_lists) do
    list_of_lists
    |> reduce([], &prepend_reversed(&2,&1))
    |> reverse
  end
end

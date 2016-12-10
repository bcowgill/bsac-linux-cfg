defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count(l) do
    1 + count(tl(l))
  end

  @spec reverse(list) :: list
  def reverse([]), do: []
  # def reverse([head , []]), do: [head]
  # def reverse([head , tail]) do
  #   [tail, head]
  # end
  def reverse(list) do
    reduce(list, [], fn (item, reversed) -> append(item, reversed) end)
  end

  # TODO implement
  defp flatten(list), do: List.flatten(list)

  @spec map(list, (any -> any)) :: list
  def map(list, func) do
    for datum <- list do
      func.(datum)
    end
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
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

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, f), do: acc
  def reduce([ head | tail ], acc, f) do
    reduce(tail, f.(head, acc), f)
  end

  @spec append(list, list) :: list
  # MUSTDO implement without ++
  def append(a, b), do: listify(a) ++ listify(b)

  defp listify(a) when is_list(a), do: a
  defp listify(a), do: [a]

  @spec concat([[any]]) :: [any]
  def concat(list_of_lists) do
    reduce(list_of_lists, [], fn (list,joined) -> append(joined, list) end)
  end
end

defmodule Issues.TableFormatter do

# Example of generated output we would create
#
#  #  | created_at           | title
# ----+----------------------+-----------------------------------------
# 889 | 2013-03-16T22:03:13Z | MIX_PATH environment variable (of sorts)
# 892 | 2013-03-20T19:22:07Z | Enhanced mix test --cover
# 893 | 2013-03-21T06:23:00Z | mix test time reports
# 898 | 2013-03-23T19:19:08Z | Add mix compile --warnings-as-errors

  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
         puts_one_line_in_columns(headers, format)
         IO.puts(separator(column_widths))
         puts_in_columns(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end

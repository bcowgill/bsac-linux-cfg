defmodule Issues.TableFormatter do
  @moduledoc """
  Formats a list of github issues into a user readable plaintext table.

  ## Example of generated table output:
  ```
   #  | created_at           | title
  ----+----------------------+-----------------------------------------
  889 | 2013-03-16T22:03:13Z | MIX_PATH environment variable (of sorts)
  892 | 2013-03-20T19:22:07Z | Enhanced mix test --cover
  893 | 2013-03-21T06:23:00Z | mix test time reports
  898 | 2013-03-23T19:19:08Z | Add mix compile --warnings-as-errors
  ```
  """

  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  @doc """
  Print out a plain text table of issues formatted into fixed width
  columns.

  `rows` A list of maps containing the issues to display.

  `headers` A list of the only field names from the issues maps to display in the table.

  """
  @spec print_table_for_columns([Map.t], [String.t]) :: nil
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
         puts_one_line_in_columns(headers, format)
         IO.puts(separator_row(column_widths))
         puts_in_columns(data_by_columns, format)
    end
  end

  @doc """
  Splits the list of issue maps into specific columns.

  Returns a list of lists containing the column information.
  """
  @spec split_into_columns([Map.t], [String.t]) :: [[String.t]]
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
  Convert data into a printable string.
  """
  @spec printable(any) :: String.t
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  @doc """
  Calculate the column width for each column based on the length of the longest entry for the column.

  Returns a list of maximum column widths for the table.
  """
  @spec widths_of([[String.t]]) :: [Integer.t]
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  @doc """
  Construct an output format string for a row of data in the table.

  `column_widths` List of maximum column width for each table column.

  Returns a single string to format the table columns in fixed width columns.
  """
  @spec format_for([Integer.t]) :: [String.t]
  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  @doc """
  Produce the separator row between the table header and the body of the table.
  """
  @spec separator_row([Integer.t]) :: String.t
  def separator_row(column_widths) do
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

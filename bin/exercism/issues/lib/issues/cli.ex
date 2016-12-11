defmodule Issues.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project.
  """

  import Issues.TableFormatter, only: [ print_table_for_columns: 2 ]

  @typedoc "The command line parameters"
  @type argv :: [String.t]

  @default_count 4
  @fields ~W(id created_at title)

  @doc """
  A default operation for this module for testing or performance profiling.
  """
  def default(), do: main(['elixir-lang', 'elixir'])

  @doc """
  Main program which parses the command line arguments and starts the main processing task.
  """
  @spec main(argv) :: nil
  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case  parse  do

    { [ help: true ], _, _ }
      -> :help

    { _, [ user, project, count ], _ }
      -> { user, project, count |> String.trim |> String.to_integer }

    { _, [ user, project ], _ }
      -> { user, project, @default_count }

    _ -> :help

    end
  end

  @doc """
  Displays help to the user or fetches issues from github and displays them.
  """
  def process(:help) do
    IO.puts """
    usage:  issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> print_table_for_columns(@fields)
  end

  @doc """
  Handles the http response from github showing an error or returning the body.

  The http response is a Tuple containing { :ok, body } or { :error, error }
  """
  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  @doc """
  Sorts the github issues by created date/time strings.

  ## Examples

  ```
  iex> Issues.CLI.sort_into_ascending_order([%{"created_at" => "b"}, %{"created_at" => "a"}])
  [%{"created_at" => "a"}, %{"created_at" => "b"}]

  ```
  """
  def sort_into_ascending_order(list_of_issues) do
    Enum.sort(list_of_issues, &sort_by_created_at/2)
  end

  defp sort_by_created_at(less, more) do
    sort_key(less) <= sort_key(more)
  end

  defp sort_key(issue) do
    Map.get(issue, "created_at")
  end

end

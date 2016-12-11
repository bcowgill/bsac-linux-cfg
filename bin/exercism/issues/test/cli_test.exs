defmodule CliTest do
  use ExUnit.Case
  doctest Issues.CLI

  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1
  ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "  99  "]) == { "user", "project", 99 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort ascending orders the correct way cab" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{a b c}
  end

  test "sort ascending date orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(~W{
      2016-05-13T06:51:53Z
      2014-07-01T08:36:51Z
      2015-04-07T22:12:11Z
    }))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~W{
      2014-07-01T08:36:51Z
      2015-04-07T22:12:11Z
      2016-05-13T06:51:53Z
    }
  end

  defp fake_created_at_list(values) do
    for value <- values,
    do: %{"created_at" => value, "other_data" => "xxx"}
  end

end

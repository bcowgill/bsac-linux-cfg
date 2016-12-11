defmodule Issues do
  @moduledoc """
  This application displays a short list of the oldest issues from a github project.
  """

  import Issues.CLI, only: [ default: 0 ]

  @doc """
  Perform a default run of the application for testing or performance profiling.
  """
  def default() do
    Issues.CLI.default()
  end
end

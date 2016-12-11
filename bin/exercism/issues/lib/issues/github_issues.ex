defmodule Issues.GithubIssues do
  @moduledoc """
  Fetches issues from a user's github project and returns either a list of maps or error information.
  """

  @user_agent  [ {"User-agent", "Elixir dave@pragprog.com"} ]

  # use a module attribute to fetch the value at compile time
  @github_url Application.get_env(:issues, :github_url)

  require Logger

  @doc """
  Fetch issues from a github user's project.

  `user` The github user to query.

  `project` The github users's project to fetch issues from.

  Returns a tuple of :ok or :error along with a list of maps or an error message.

  `{ :ok, [issues_map] }`

  `{ :error, error_message }`
  """
  @spec fetch(String.t, String.t) :: Tuple.t
  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @doc """
  Produce the url of a github user's project.
  """
  @spec issues_url(String.t, String.t) :: String.t
  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  @doc """
  Transform the http json response into an erlang object or an error message.
  """
  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful reponse"
    Logger.debug fn ->inspect (body) end

    { :ok, Poison.Parser.parse!(body) }
  end

  def handle_response({ _, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"

    { :error, Poison.Parser.parse!(body) }
  end

end


defmodule Sequence do
  use Application

  @initial_value 58008

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    { :ok, _supervisor_pid } = Sequence.Supervisor.start_link(@initial_value)

  end
end

defmodule Sequence do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, initial_number) do
    import Supervisor.Spec, warn: false

    { :ok, _supervisor_pid } = Sequence.Supervisor.start_link(
      Application.get_env(:sequence, :initial_number))

  end
end


defmodule Sequence.Supervisor do
  use Supervisor

  def start_link(initial_number) do
    result = {:ok, supervisor_pid } = Supervisor.start_link(
	  __MODULE__,
	  [initial_number])

    start_workers(supervisor_pid, initial_number)
    result
  end

  def start_workers(supervisor_pid, initial_number) do
    # Start the stash worker
    {:ok, stash_pid} =
       Supervisor.start_child(supervisor_pid,
	     worker(Sequence.Stash, [initial_number]))

    # and then the subsupervisor for the actual sequence server
    Supervisor.start_child(supervisor_pid,
	  supervisor(Sequence.SubSupervisor, [stash_pid]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end

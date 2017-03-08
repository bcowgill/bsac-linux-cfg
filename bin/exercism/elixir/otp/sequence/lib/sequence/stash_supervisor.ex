
defmodule Sequence.StashSupervisor do
  use Supervisor

  def start_link(stash_pid, worker_type) do
    {:ok, _supervisor_pid} = Supervisor.start_link(__MODULE__, [stash_pid, worker_type])
  end

  def init([stash_pid, worker_type]) do
    child_processes = [ worker(worker_type, [stash_pid]) ]
    supervise child_processes, strategy: :one_for_one
  end
end

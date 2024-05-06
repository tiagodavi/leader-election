defmodule App.Cluster do
  @moduledoc """
  Used to start the Cluster
  """
  @spec init() :: {:error, :cluster_not_formed} | {:ok, [{any(), any()}], [{any(), any()}]}
  def init do
    nodes = [Node.self() | Node.list()]

    :rpc.multicall(nodes, :ra, :start, [])

    machine = {:module, App.StateMachine, %{}}

    :ra.start_cluster(:default, "cluster", machine, Enum.map(nodes, &{__MODULE__, &1}))
  end
end

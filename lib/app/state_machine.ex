defmodule App.StateMachine do
  @behaviour :ra_machine

  @impl true
  def init(_conf) do
    %{}
  end

  @impl true
  def apply(_meta, {:write, key, value}, state) do
    {Map.put(state, key, value), :ok, []}
  end

  @impl true
  def apply(_meta, {:read, key}, state) do
    {state, Map.get(state, key), []}
  end
end

defmodule AppWeb.AppController do
  use Phoenix.Controller

  def index(conn, _) do
    name =
      App.Cluster
      |> :ra.member_overview()
      |> case do
        {:ok, %{id: {_, id}, leader_id: {_, leader_id}}, _} ->
          if id == leader_id, do: "Goose", else: "Duck"

        _ ->
          "Goose"
      end

    json(conn, %{name: name})
  end
end

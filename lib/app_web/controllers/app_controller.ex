defmodule AppWeb.AppController do
  use Phoenix.Controller

  def index(conn, _) do
    name = if App.Cluster.leader?(), do: "Goose", else: "Duck"

    json(conn, %{name: name})
  end
end

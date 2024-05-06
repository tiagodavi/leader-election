defmodule App.ClusterTest do
  use ExUnit.ClusteredCase

  scenario "given a healthy cluster", cluster_size: 4 do
    node_setup(:start_apps)

    test "ensures only one is a leader", %{cluster: c} do
      leaders = Cluster.map(c, App.Cluster, :leader?, [])

      assert Enum.count(leaders, & &1) == 1
    end
  end

  scenario "given a partitioned cluster", cluster_size: 3 do
    node_setup(:start_apps)

    test "ensures a new leader will take place the previous one", %{cluster: c} do
      [x, y, z] = Cluster.members(c)

      x0 = Cluster.call(x, App.Cluster, :leader?, [])
      y0 = Cluster.call(y, App.Cluster, :leader?, [])
      z0 = Cluster.call(z, App.Cluster, :leader?, [])

      nodes = [x: {x, x0}, y: {y, y0}, z: {z, z0}]

      {_current_leader, {leader_node, true}} =
        Enum.find(nodes, fn {_key, {_node, leader?}} -> leader? == true end)

      assert :ok = Cluster.stop_node(c, leader_node)

      remaining_members = Cluster.members(c)

      refute leader_node in remaining_members

      leaders = Cluster.map(c, App.Cluster, :leader?, [])

      assert Enum.count(leaders, & &1) == 1
    end
  end

  def start_apps(_context) do
    Application.ensure_all_started(:app)
    App.Cluster.init()

    :ok
  end
end

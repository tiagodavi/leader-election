# App

This is a very simple distributed phoenix app with leader election.

`mix local.rebar --force`

Internally it relies on libcluster and raft: 

- https://github.com/bitwalker/libcluster
- https://github.com/rabbitmq/ra

You can increase the number of `NODES` as you wish as long as each NODE is part of the `NODES` variable list as example below.

Each NODE must run on its own particular `PORT` to avoid conflicts. 

To start 4 NODES, run each line on a different terminal instance:

```bash
PORT=4000 NODES=n0@127.0.0.1,n1@127.0.0.1,n2@127.0.0.1,n3@127.0.0.1 iex --name n0@127.0.0.1 -S mix phx.server
```

```bash
PORT=4001 NODES=n0@127.0.0.1,n1@127.0.0.1,n2@127.0.0.1,n3@127.0.0.1 iex --name n1@127.0.0.1 -S mix phx.server
```

```bash
PORT=4002 NODES=n0@127.0.0.1,n1@127.0.0.1,n2@127.0.0.1,n3@127.0.0.1 iex --name n2@127.0.0.1 -S mix phx.server
```

```bash
PORT=4003 NODES=n0@127.0.0.1,n1@127.0.0.1,n2@127.0.0.1,n3@127.0.0.1 iex --name n3@127.0.0.1 -S mix phx.server
```

Choose any of them to start the Cluster formation:

This command will start raft for all available nodes. 

```bash
App.Cluster.init()
```

You can then access the host URL, for example `http://localhost::4000` and verify that there will always be a Goose and multiple Ducks even in case of network partition.

Alternatives to solve the same problem are:

Consul, Zookeeper, Etcd.
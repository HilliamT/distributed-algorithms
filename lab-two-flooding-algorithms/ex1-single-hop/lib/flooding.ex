
# distributed algorithms, n.dulay, 4 jan 21
# basic flooding, v1

# flood message through 1-hop (fully connected) network

defmodule Flooding do

def start do
  config = Helper.node_init()
  start(config.start_function, config)
end # start/0

defp start(:cluster_wait, _), do: :skip
defp start(:cluster_start, config) do
  IO.puts "-> Flooding at #{Helper.node_string()}"

  # create peer network
  peer_pids = Enum.map(0..(config.n_peers - 1), fn x -> Node.spawn(:"peer#{x}_#{config.node_suffix}", Peer, :start, []) end)
  Enum.map(peer_pids, fn pid -> send pid, { :register_peers, peer_pids } end)

  # send first peer a hello message
  send Enum.at(peer_pids, 0), { :hello }
end # start

end # module -----------------------

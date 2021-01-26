
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
  peers = Enum.map(0..(config.n_peers - 1), fn x -> Node.spawn(:"peer#{x}_#{config.node_suffix}", Peer, :start, []) end)

  bind(peers, 0, [1, 6]) # peer 0's neighbours are peer 1 and 6
  bind(peers, 1, [0, 2, 3])
  bind(peers, 2, [1, 3, 4])
  bind(peers, 3, [1, 2, 5])
  bind(peers, 4, [2])
  bind(peers, 5, [3])
  bind(peers, 6, [0, 7])
  bind(peers, 7, [6, 8, 9])
  bind(peers, 8, [7, 9])
  bind(peers, 9, [7, 8])

  # send first peer a hello message
  send Enum.at(peers, 0), { :hello, Helper.node_string() }
end # start

# Binds each Peer to its neighbours
defp bind(pids, process_no, peer_nos) do
  new_peers = Enum.map(peer_nos, fn peer_no -> Enum.at(pids, peer_no) end)
  send Enum.at(pids, process_no), { :register_peers, new_peers }
end

end # module -----------------------

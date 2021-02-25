
# distributed algorithms, n.dulay, 4 jan 21
# lab3 - broadcast algorithms

# v1 - elixir broadcast

defmodule Broadcast do

def start do
  config = Helper.node_init()
  start(config.start_function, config)
end # start/0

defp start(:cluster_wait, _), do: :skip
defp start(:cluster_start, config) do
  IO.puts "--> Broadcast at #{Helper.node_string()}"

  # add your code here
  peers = Enum.map(0..(config.n_peers - 1), fn x -> Node.spawn(:"peer#{x}_#{config.node_suffix}", Peer, :start, []) end)

  Enum.map(0..(config.n_peers - 1), fn i -> send Enum.at(peers, i), { :bind, peers, i } end)
  for peer <- peers, do: send peer, { :broadcast, 1000, 3000 }
end

end # module ------------------------------

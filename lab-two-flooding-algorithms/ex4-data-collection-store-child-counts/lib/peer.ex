
# distributed algorithms, n.dulay, 4 jan 21
# basic flooding, v1

defmodule Peer do

def start do
  IO.puts "Peer started at #{Helper.node_string()}"
  receive do
    { :register_peers, peers } ->
      count_hellos(peers, 0, "", 0)
  end
end

def count_hellos(peers, hellos, known_parent, no_of_children) do
  receive do
    { :hello, parent } ->

      # Hellos check still need to instantiate spanning tree
      if (hellos == 0) do
        # Send hellos to peers
        Enum.map(peers, fn peer -> send peer, { :hello, self() } end)

        # Tell parent of this child
        send parent, { :child }
      end

      # Increment hellos seen
      count_hellos(peers, hellos + 1, (if known_parent != "", do: known_parent, else: parent), no_of_children)

    { :child } ->

      # Increment child count (as constructed by "hello" spanning tree)
      count_hellos(peers, hellos, known_parent, no_of_children + 1)
    after
      1000 -> IO.puts "Peer #{Helper.node_string()} Parent #{inspect(known_parent)} Children = #{no_of_children}"
  end
end

end # module ------------------------


# distributed algorithms, n.dulay, 4 jan 21
# basic flooding, v1

defmodule Peer do

def start do
  IO.puts "Peer started at #{Helper.node_string()}"
  receive do
    { :register_peers, peers } ->
      count_hellos(peers, 0, "")
  end
end

def count_hellos(peers, hellos, known_parent) do
  receive do
    { :hello, parent } ->
      if (hellos == 0) do
        # Send hellos to peers
        Enum.map(peers, fn peer -> send peer, { :hello, Helper.node_string() } end)
      end

      # Increment hellos seen
      count_hellos(peers, hellos + 1, (if known_parent != "", do: known_parent, else: parent))
    after
      1000 -> IO.puts "Peer #{Helper.node_string()} Parent #{known_parent} Messages seen = #{hellos}"
  end
end

end # module ------------------------

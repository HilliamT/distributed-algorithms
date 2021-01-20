
# distributed algorithms, n.dulay, 4 jan 21
# simple client-server, v1

defmodule ClientServer do

def start do 
  config = Helper.node_init()
  start(config.start_function, config) 
end

defp start(:single_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"

  # Node.spawn/X returns server PID, which we can funnel as argument to our clients construction
  server = Node.spawn(:'clientserver_#{config.node_suffix}', Server, :start, [])
  _client = Node.spawn(:'clientserver_#{config.node_suffix}', Client, :start, [server])
  
  # We now don't need to perform an initial Server-client binding
  # send server, { :bind, client }
  # send client, { :bind, server }
end

defp start(:cluster_wait, _), do: :skip
defp start(:cluster_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"
  server = Node.spawn(:'server_#{config.node_suffix}', Server, :start, [])
  _client = Node.spawn(:'client_#{config.node_suffix}', Client, :start, [server])
  
  # send server, { :bind, client }
  # send client, { :bind, server }
end

end # module -----------------------


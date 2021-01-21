
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
  Process.sleep(500) # Allow server to startup before spawning clients

  # Spawn 'config.clients' amount of clients under a single node
  for _x <- 0..config.clients do Node.spawn(:'clientserver_#{config.node_suffix}', Client, :start, [server]) end
  
  # We now don't need to perform an initial Server-client binding
  # send server, { :bind, client }
  # send client, { :bind, server }
end

defp start(:cluster_wait, _), do: :skip
defp start(:cluster_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"
  server = Node.spawn(:'server_#{config.node_suffix}', Server, :start, [])
  Process.sleep(500) # Allow server to startup before spawning clients

  # Spawn 'config.clients' amount of clients from multiple nodes
  for x <- 0..config.clients do Node.spawn(:'client#{x}_#{config.node_suffix}', Client, :start, [server]) end
  
  # send server, { :bind, client }
  # send client, { :bind, server }
end

end # module -----------------------


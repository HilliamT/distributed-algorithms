
# distributed algorithms, n.dulay, 4 jan 21
# simple client-server, v1

defmodule Client do

  def start(server) do
    IO.puts "-> Client at #{Helper.node_string()}"
    next(server)
  end

  defp next(server) do
    send server, { :circle, [self(), 1.0] }
    receive do
    { :result, area } -> IO.puts "#{inspect(self())}:  Area is #{area}"
    end
    Process.sleep(1000)
    next(server)
  end

end # module -----------------------


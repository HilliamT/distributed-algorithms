
# distributed algorithms, n.dulay, 4 jan 21
# simple client-server, v1

defmodule Client do

  def start(server) do
    IO.puts "-> Client at #{Helper.node_string()}"
    next(server)
  end

  defp next(server) do
    
    # 1/3 chance to send server a respective circle / square / triangle request
    case Helper.random(3) do
      1 -> send server, { :circle, [self(), 1.0] }
      2 -> send server, { :square, [self(), 1.0] }
      3 -> send server, { :triangle, [self(), 2.0, 2.5, 3.0] }
    end
    receive do
    { :result, area } -> IO.puts "#{inspect(self())}:  Area is #{area}"
    end
    
    # Make client sleep 1-3 seconds before next request
    Process.sleep(Helper.random(3) * 1000)
    next(server)
  end

end # module -----------------------


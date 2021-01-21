
# distributed algorithms, n.dulay, 4 jan 18
# simple client-server, v1

defmodule Server do
 
# We can now remove references to 'client', by dealing with routing on a per-request basis
def start do 
  IO.puts "-> Server at #{Helper.node_string()}"
  next() 
end # start
 
defp next() do
  receive do
  { :circle, [pid, radius] } -> 
    send pid, { :result, 3.14159 * radius * radius }
  { :square, [pid, side] } -> 
    send pid, { :result, side * side }
  { :triangle, [pid, a, b, c] } ->
    # Heron's formula
    s = (a + b + c) / 2
    send pid, { :result, Helper.sqrt(s * (s - a) * (s - b) * (s - c))}
  end
  next()
end # next

end # module -----------------------


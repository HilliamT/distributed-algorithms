defmodule Peer do

def start do
  receive do
    { :bind, peers, peer_number } ->
      next(peer_number, peers, Map.new, Map.new)
  end
end

defp next(peer_number, peers, sent, received) do
  receive do
    { :broadcast, max_broadcasts, timeout } ->
      Process.send_after(self(), { :print }, timeout)
      send self(), { :send_broadcast, max_broadcasts }
      next(peer_number, peers, sent, received)

    { :send_broadcast, broadcasts_left } ->

      sent = Enum.reduce(0..(Enum.count(peers) - 1), sent, fn i, sent ->
        send Enum.at(peers, i), { :received_broadcast, peer_number }
        _sent = Map.put(sent, i, Map.get(sent, i, 0) + 1)
      end)

      if (broadcasts_left > 1), do: send self(), { :send_broadcast, broadcasts_left - 1 }
      next(peer_number, peers, sent, received)

    { :received_broadcast, peer_num } ->
      next(peer_number, peers, sent, Map.put(received, peer_num, Map.get(received, peer_num, 0) + 1))

    { :print } ->
      str_output = "Peer#{peer_number}: "
      str_output = Enum.reduce(0..(Enum.count(peers) - 1), str_output, fn i, str ->
        _str = "#{str} #{i} => {#{Map.get(received, i)}, #{Map.get(sent, i)}}"
      end)
      IO.inspect str_output
  end
end


end

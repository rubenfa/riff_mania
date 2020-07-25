defmodule GameApi.Players.Player do
  defstruct id: "", name: "", status: :waiting

  alias GameApi.Players.Player

  def new(name) do
    %Player{
      id: random_id(20),
      name: name
    }
  end

  defp random_id(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end

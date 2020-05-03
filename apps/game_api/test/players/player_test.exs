defmodule GameApi.Tests.Players.Player do
  use ExUnit.Case, async: true

  alias GameApi.Players.Player

  test "A player is created with unique id" do
    player1 = Player.new("Player1")

    assert player1.name == "Player1"
    assert String.length(player1.id) == 20
  end
end

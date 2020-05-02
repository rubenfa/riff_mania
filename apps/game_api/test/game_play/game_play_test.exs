defmodule GameApi.Tests.GamePlay do
  use ExUnit.Case, async: true

  alias GameApi.{GamePlay, SongRandomizer}

  setup do
    SongRandomizer.start_link()
    :ok
  end

  test "Creating a GamePlay with 3 turns" do
    game_play = GamePlay.new(turns: 3)
    wrong_songs = Enum.flat_map(game_play.turns, fn g -> g.wrong_songs end)

    assert Enum.count(game_play.turns) == 3
    assert Enum.count(wrong_songs) == 9
  end

  test "Creating a GamePlay with 3 turns and 4 wrong_songs" do
    game_play = GamePlay.new(turns: 3, wrong_songs_number: 4)
    wrong_songs = Enum.flat_map(game_play.turns, fn g -> g.wrong_songs end)

    assert Enum.count(game_play.turns) == 3
    assert Enum.count(wrong_songs) == 12
  end
end

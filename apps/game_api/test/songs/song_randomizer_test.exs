defmodule GameApi.Tests.SongRandomizerTests do
  use ExUnit.Case, async: true

  alias GameApi.{Song, SongRandomizer}

  test "Should return one song" do
    assert [%Song{}] = SongRandomizer.get(1)
  end

  test "Should return 3 songs" do
    assert [%Song{}, %Song{}, %Song{}] = SongRandomizer.get(3)
  end

  test "Should return 10 different songs" do
    for _n <- 1..100 do
      songs = SongRandomizer.get(10)

      all_songs_count = Enum.count(songs)
      all_uniq_songs_count = songs |> Enum.map(fn s -> s.title end) |> Enum.uniq() |> Enum.count()

      assert all_songs_count == all_uniq_songs_count
    end
  end

  test "Raises error ir there are not enought songs to get" do
    assert_raise ArgumentError, fn -> SongRandomizer.get(50) end
  end
end

defmodule GameApi.Tests.GamePlayTests do
  use ExUnit.Case, async: true

  alias GameApi.{GamePlay, Song, SongGroup}

  test "Should return a new song group" do
    songs_group = get_not_repeated_songs_list() |> GamePlay.new()

    assert [
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Should return a new song group with 4 other songs" do
    songs_group = get_not_repeated_songs_list() |> GamePlay.new(wrong_songs_number: 4)

    assert [
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Should return 2 new song groups with 4 other songs" do
    songs_group = get_not_repeated_songs_list() |> GamePlay.new(groups: 2, wrong_songs_number: 4)

    assert [
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}, %Song{}]
             },
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Should return 3 new song groups with 3 other songs" do
    songs_group = get_not_repeated_songs_list() |> GamePlay.new(groups: 3)

    assert [
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}]
             },
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}]
             },
             %SongGroup{
               right_song: %Song{},
               wrong_songs: [%Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Songs in a group should be different" do
    for _n <- 1..100 do
      [songs_group] = get_not_repeated_songs_list() |> GamePlay.new()

      all_titles = [
        songs_group.right_song.title | Enum.map(songs_group.wrong_songs, fn o -> o.title end)
      ]

      all_titles_length = all_titles |> Enum.count()
      all_uniq_titles_length = all_titles |> Enum.uniq() |> Enum.count()

      assert all_titles_length == all_uniq_titles_length
    end
  end

  test "Raises error with a duplicated song" do
    assert_raise(ArgumentError, fn -> get_repeated_songs_list() |> GamePlay.new() end)
  end

  test "Raises error if we ask for to many songs" do
    assert_raise(ArgumentError, fn ->
      get_not_repeated_songs_list() |> GamePlay.new(groups: 3, wrong_songs_number: 5)
    end)
  end

  defp get_not_repeated_songs_list() do
    [
      %Song{title: "1", path: "a"},
      %Song{title: "2", path: "a"},
      %Song{title: "3", path: "a"},
      %Song{title: "4", path: "a"},
      %Song{title: "5", path: "a"},
      %Song{title: "6", path: "a"},
      %Song{title: "7", path: "a"},
      %Song{title: "8", path: "a"},
      %Song{title: "9", path: "a"},
      %Song{title: "10", path: "a"},
      %Song{title: "11", path: "a"},
      %Song{title: "12", path: "a"}
    ]
  end

  defp get_repeated_songs_list() do
    [
      %Song{title: "1", path: "a"},
      %Song{title: "1", path: "a"},
      %Song{title: "1", path: "a"},
      %Song{title: "1", path: "a"},
      %Song{title: "1", path: "a"},
      %Song{title: "1", path: "a"},
      %Song{title: "2", path: "a"},
      %Song{title: "2", path: "a"},
      %Song{title: "2", path: "a"},
      %Song{title: "2", path: "a"},
      %Song{title: "2", path: "a"},
      %Song{title: "2", path: "a"}
    ]
  end
end

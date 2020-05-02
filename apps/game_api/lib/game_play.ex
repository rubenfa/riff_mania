defmodule GameApi.GamePlay do
  @moduledoc """
  A GamePlay controls the state of a play of `riff_mania`
  """
  defstruct turns: []

  alias GameApi.SongGroup

  def new(songs_list, opts \\ []) do
    groups_number = Keyword.get(opts, :groups, 1)
    wrong_songs_number = Keyword.get(opts, :wrong_songs_number, 3)

    if repeated_songs?(songs_list),
      do: raise(ArgumentError, message: "There are duplicated songs in the list")

    generate_groups(groups_number, wrong_songs_number, songs_list)
  end

  def generate_groups(1, others_number, songs_list) do
    {group, _songs_list} = generate_group(songs_list, others_number)
    [group]
  end

  def generate_groups(groups_number, others_number, songs_list) do
    {group, songs_list} = generate_group(songs_list, others_number)
    groups = generate_groups(groups_number - 1, others_number, songs_list)

    [group | groups]
  end

  def generate_group(songs_list, others_number) do
    {right_song, songs_list} = get_random_song(songs_list)
    {other_songs, songs_list} = generate_wrong_songs(others_number, songs_list)

    {SongGroup.new(right_song, other_songs), songs_list}
  end

  defp generate_wrong_songs(others_number, songs_list, acc \\ [])

  defp generate_wrong_songs(1, songs_list, acc) do
    {song, songs_list} = get_random_song(songs_list)
    {[song | acc], songs_list}
  end

  defp generate_wrong_songs(others_number, songs_list, acc) do
    {song, songs_list} = get_random_song(songs_list)

    generate_wrong_songs(others_number - 1, songs_list, [song | acc])
  end

  defp get_random_song([]),
    do: raise(ArgumentError, message: "There are not enough songs to generate a gameplay")

  defp get_random_song(songs_list) do
    [picked | rest] = Enum.shuffle(songs_list)
    {picked, rest}
  end

  defp repeated_songs?(songs_list) do
    Enum.count(songs_list) !== uniq_song_titles(songs_list)
  end

  defp uniq_song_titles(songs_list) do
    songs_list
    |> Enum.map(fn s -> s.title end)
    |> Enum.uniq()
    |> Enum.count()
  end
end

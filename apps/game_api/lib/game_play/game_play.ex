defmodule GameApi.GamePlay do
  @moduledoc """
  A GamePlay controls the state of a play of `riff_mania`
  """
  defstruct turns: [], players: []

  alias GameApi.GamePlay.TurnGenerator

  @turns Application.fetch_env!(:game_api, :turns)
  @wrong_songs_number Application.fetch_env!(:game_api, :wrong_songs_number)

  def new(opts \\ []) do
    turns = Keyword.get(opts, :turns, @turns)
    wrong_songs_number = Keyword.get(opts, :wrong_songs_number, @wrong_songs_number)
    songs_list = get_song_list(turns, wrong_songs_number)

    %GameApi.GamePlay{
      turns: TurnGenerator.new(songs_list, groups: turns, wrong_songs_number: wrong_songs_number)
    }
  end

  defp get_song_list(turns, wrong_songs_number) do
    GameApi.SongRandomizer.get(turns * (wrong_songs_number + 1))
  end
end

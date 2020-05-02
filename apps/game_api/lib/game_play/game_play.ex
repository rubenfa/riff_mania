defmodule GameApi.GamePlay do
  @moduledoc """
  A GamePlay controls the state of a play of `riff_mania`
  """
  defstruct turns: []

  alias GameApi.GamePlay.TurnGenerator

  def new(opts) do
    turns = Keyword.get(opts, :turns, 10)
    wrong_songs_number = Keyword.get(opts, :wrong_songs_number, 3)
    songs_list = get_song_list(turns, wrong_songs_number)

    %GameApi.GamePlay{
      turns: TurnGenerator.new(songs_list, groups: turns, wrong_songs_number: wrong_songs_number)
    }
  end

  defp get_song_list(turns, wrong_songs_number) do
    GameApi.SongRandomizer.get(turns * (wrong_songs_number + 1))
  end
end

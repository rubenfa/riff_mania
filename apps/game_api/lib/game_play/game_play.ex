defmodule GameApi.GamePlay do
  @moduledoc """
  A GamePlay controls the state of a play of `riff_mania`
  """
  defstruct turns: [], players: [], status: :awaiting_players

  alias GameApi.GamePlay
  alias GameApi.GamePlay.{StatusChanger, TurnGenerator}

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

  def add_player(%GamePlay{status: :awaiting_players} = game_play, player) do
    game_play =
      game_play
      |> Map.put(:players, [player | game_play.players])
      |> StatusChanger.change_from(:awaiting_players)

    {:ok, game_play}
  end

  def add_player(%GamePlay{status: _status} = game_play, _player), do: {:error, game_play}

  defp get_song_list(turns, wrong_songs_number) do
    GameApi.SongRandomizer.get(turns * (wrong_songs_number + 1))
  end
end

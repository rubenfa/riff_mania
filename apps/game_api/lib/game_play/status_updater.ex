defmodule GameApi.GamePlay.StatusChanger do
  alias GameApi.GamePlay
  @max_players Application.fetch_env!(:game_api, :max_players)

  def change_from(%GamePlay{players: players} = game_play, :awaiting_players)
      when length(players) == @max_players do
    game_play |> Map.put(:status, :awaiting_start)
  end

  def change_from(%GamePlay{players: players} = game_play, :awaiting_start) do
    case Enum.all?(players, fn p -> p.status == :ready end) do
      true -> game_play |> Map.put(:status, :on_turn)
      false -> game_play
    end
  end

  def change_from(game_play, _old_status), do: game_play
end

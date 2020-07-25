defmodule GameApi.Tests.GamePlay do
  use ExUnit.Case, async: true

  alias GameApi.GamePlay
  alias GameApi.Players.Player

  describe "Gameplay creation" do
    test "Creating a GamePlay with 3 turns" do
      game_play = GamePlay.new()
      wrong_songs = Enum.flat_map(game_play.turns, fn g -> g.wrong_songs end)

      assert Enum.count(game_play.turns) == 3
      assert Enum.count(wrong_songs) == 9
      assert :awaiting_players = game_play.status
    end

    test "Creating a GamePlay with 3 turns and 4 wrong_songs" do
      game_play = GamePlay.new(turns: 3, wrong_songs_number: 4)
      wrong_songs = Enum.flat_map(game_play.turns, fn g -> g.wrong_songs end)

      assert Enum.count(game_play.turns) == 3
      assert Enum.count(wrong_songs) == 12

      assert :awaiting_players = game_play.status
    end
  end

  describe "Gameplay players" do
    test "A player can be added if the status is :waiting_players" do
      player1 = Player.new("MegaPlayer")
      gameplay_original = GamePlay.new()

      assert(gameplay_original.status == :awaiting_players)

      {:ok, gameplay_with_players} =
        gameplay_original
        |> GamePlay.add_player(player1)

      assert player1 == Enum.at(gameplay_with_players.players, 0)
    end

    test "We can add two players if the status is :waiting_players" do
      player1 = Player.new("MegaPlayer")
      player2 = Player.new("TopPlayer")
      game_play = GamePlay.new()

      assert(game_play.status == :awaiting_players)

      {:ok, game_play} =
        game_play
        |> GamePlay.add_player(player1)

      {:ok, game_play} =
        game_play
        |> GamePlay.add_player(player2)

      assert [player2, player1] = game_play.players
    end

    test "We cannot add more players if the gameplay is full" do
      player1 = Player.new("MegaPlayer")
      player2 = Player.new("TopPlayer")
      player3 = Player.new("YupPlayer")
      player4 = Player.new("AsPlayer")
      player5 = Player.new("ZetaPlayer")

      game_play = GamePlay.new()

      assert(game_play.status == :awaiting_players)

      {:ok, game_play} =
        game_play
        |> GamePlay.add_player(player1)

      assert(game_play.status == :awaiting_players)

      {:ok, game_play} =
        game_play
        |> GamePlay.add_player(player2)

      assert(game_play.status == :awaiting_players)

      {:ok, game_play} =
        game_play
        |> GamePlay.add_player(player3)

      assert(game_play.status == :awaiting_players)

      {:ok, game_play} =
        game_play
        |> GamePlay.add_player(player4)

      assert(game_play.status == :awaiting_start)

      {:error, game_play} =
        game_play
        |> GamePlay.add_player(player5)

      assert [player4, player3, player2, player1] = game_play.players
      assert(game_play.status == :awaiting_start)
    end
  end

  describe "Gameplay starts" do
    test "A gameplay changes status when all players are ready" do
      player1 = Player.new("MegaPlayer")
      player2 = Player.new("TopPlayer")
      player3 = Player.new("YupPlayer")
      player4 = Player.new("AsPlayer")

      {:ok, game_play} =
        GamePlay.new()
        |> GamePlay.add_players([player1, player2, player3, player4])

      assert(game_play.status == :awaiting_start)

      {:ok, game_play} = GamePlay.player_ready(game_play, player1)
      player1 = Enum.find(game_play.players, fn p -> p.id == player1.id end)
      assert player1.status == :ready
      assert(game_play.status == :awaiting_start)

      {:ok, game_play} = GamePlay.player_ready(game_play, player2)
      player2 = Enum.find(game_play.players, fn p -> p.id == player2.id end)
      assert player2.status == :ready
      assert(game_play.status == :awaiting_start)

      {:ok, game_play} = GamePlay.player_ready(game_play, player3)
      player3 = Enum.find(game_play.players, fn p -> p.id == player3.id end)
      assert player3.status == :ready
      assert(game_play.status == :awaiting_start)

      {:ok, game_play} = GamePlay.player_ready(game_play, player4)
      player4 = Enum.find(game_play.players, fn p -> p.id == player4.id end)
      assert player4.status == :ready
      assert(game_play.status == :ready_to_start)
    end
  end
end

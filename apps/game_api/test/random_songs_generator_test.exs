defmodule GameApi.Tests.SongRandomizerTest do
  use ExUnit.Case, async: true

  alias GameApi.{Song, SongGroup, SongRandomizer}

  setup do
    SongRandomizer.start_link()
    :ok
  end

  test "Should return a new song group" do
    songs_group = SongRandomizer.get()

    assert [
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Should return a new song group with 4 other songs" do
    songs_group = SongRandomizer.get(others: 4)

    assert [
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Should return 2 new song groups with 4 other songs" do
    songs_group = SongRandomizer.get(groups: 2, others: 4)

    assert [
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}, %Song{}]
             },
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end

  test "Should return 3 new song groups with 3 other songs" do
    songs_group = SongRandomizer.get(groups: 3)

    assert [
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}]
             },
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}]
             },
             %SongGroup{
               valid: %Song{},
               others: [%Song{}, %Song{}, %Song{}]
             }
           ] = songs_group
  end
end

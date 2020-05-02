defmodule GameApi.SongGroup do
  defstruct right_song: %{}, wrong_songs: []

  alias GameApi.{Song, SongGroup}

  def new(%Song{} = right, others) when is_list(others) do
    %SongGroup{
      right_song: right,
      wrong_songs: others
    }
  end
end

defmodule GameApi.Song do
  defstruct title: "", path: ""

  alias GameApi.Song

  def new(title, path) do
    %GameApi.Song{
      title: title,
      path: path
    }
  end
end

defmodule GameApi.SongGroup do
  defstruct valid: %{}, others: []

  alias GameApi.{Song, SongGroup}

  def new(%Song{} = valid, others) when is_list(others) do
    %SongGroup{
      valid: valid,
      others: others
    }
  end
end

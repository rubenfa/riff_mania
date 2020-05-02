defmodule GameApi.Song do
  defstruct title: "", path: ""

  def new(title, path) do
    %GameApi.Song{
      title: title,
      path: path
    }
  end
end

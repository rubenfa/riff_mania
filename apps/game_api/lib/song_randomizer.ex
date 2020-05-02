defmodule GameApi.SongRandomizer do
  alias GameApi.Song

  use GenServer

  @songs_file_path "/assets/songs.txt"

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    songs_table = :ets.new(:songs_table, [:named_table, read_concurrency: true])

    load_songs()

    {:ok, Map.put(state, :songs_table, songs_table)}
  end

  def get(songs_number) when is_integer(songs_number) do
    unless enought_songs?(songs_number) do
      raise ArgumentError, message: "There are not enought different songs"
    end

    GenServer.call(__MODULE__, {:get, songs_number})
  end

  # PRIVATE API

  def handle_call({:get, songs_number}, _from, state) do
    {:reply, read_songs(songs_number), state}
  end

  defp load_songs do
    file_path = Path.join(__DIR__, @songs_file_path)
    unless File.exists?(file_path), do: raise(File.Error, messsage: "Songs file not found")

    file_path
    |> File.stream!([], :line)
    |> Stream.map(&parse_line(&1))
    |> Stream.each(&insert_song(&1))
    |> Stream.run()
  end

  defp parse_line([""]), do: {}

  defp parse_line(line) do
    line
    |> String.split("#")
    |> create_song
  end

  defp create_song([""]), do: {}
  defp create_song([id, title, path]), do: {String.to_integer(id), Song.new(title, path)}

  def insert_song({id, song}) do
    :ets.insert(:songs_table, {id, song})
  end

  def read_songs(songs_number, acc \\ [])
  def read_songs(0, acc), do: acc

  def read_songs(songs_number, acc) do
    new_song = read_song()

    cond do
      Enum.any?(acc, fn s -> s.title == new_song.title end) -> read_songs(songs_number, acc)
      true -> read_songs(songs_number - 1, [new_song | acc])
    end
  end

  defp read_song do
    table_size = :ets.info(:songs_table, :size)

    [{_id, song}] = :ets.lookup(:songs_table, :rand.uniform(table_size))
    song
  end

  defp enought_songs?(number), do: :ets.info(:songs_table, :size) >= number
end

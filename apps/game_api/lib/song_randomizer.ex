defmodule GameApi.SongRandomizer do
  alias GameApi.{Song, SongGroup}

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

  def get(opts \\ []) do
    GenServer.call(__MODULE__, {:get, opts})
  end

  # PRIVATE API

  def handle_call({:get, opts}, _from, state) do
    groups = Keyword.get(opts, :groups, 1)
    others_number = Keyword.get(opts, :others, 3)

    groups = generate_groups([], groups, others_number)
    {:reply, groups, state}
  end

  defp generate_groups(groups, 0, _others_number), do: groups

  defp generate_groups(groups, n, others_number) do
    groups = [generate_group(others_number) | groups]
    generate_groups(groups, n - 1, others_number)
  end

  defp generate_group(others_number) do
    SongGroup.new(read_song(), generate_others([], others_number))
  end

  defp generate_others(others, 0), do: others

  defp generate_others(others, n) do
    others = [read_song() | others]

    generate_others(others, n - 1)
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

  defp read_song do
    [{_id, song}] = :ets.lookup(:songs_table, 1)
    song
  end
end

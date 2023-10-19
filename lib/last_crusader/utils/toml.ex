defmodule LastCrusader.Utils.Toml do
  @moduledoc """
    TOML strings manipulation
  """

  @type toml() :: String.t()
  @separator "+++\n"

  @doc """
    Extracts Frontmatter and Content from a Post
  """
  @spec extract_frontmatter_and_content(toml()) :: {toml(), String.t()}
  def extract_frontmatter_and_content(wholefile) do
    [_, frontmatter, markdown] = String.split(wholefile, @separator)
    {frontmatter, markdown}
  end

  @doc """
    Updates a TOML formatted front-matter
  """
  @spec update_toml(toml(), map()) :: toml()
  def update_toml(front_matter, {key, value}) do
    front_matter
    |> front_matter_to_map()
    |> Map.put(key, value)
    |> toml_map_to_string()
  end

  @doc """
    Transforms a Map representation of TOML into its String counterpart with included separators
  """
  @spec toml_map_to_string(map()) :: toml()
  def toml_map_to_string(m) do
    s = Enum.map_join(m, "\n", fn {k, v} -> to_string(k) <> " = " <> toml_value(v) end)

    @separator <> s <> "\n" <> @separator
  end

  @spec front_matter_to_map(toml()) :: map()
  def front_matter_to_map(toml) do
    toml
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn line -> key_value(line) end)
    |> Enum.chunk_every(1)
    |> Enum.map(fn [[a, b]] -> {a, b} end)
    |> Map.new()
  end

  defp key_value(line) do
    [key, value] = String.split(line, " = ")

    case String.match?(value, ~r/^\[.*\]/) do
      true -> [key, string_to_list(value)]
      false -> [key, String.replace(value, "\"", "")]
    end
  end

  defp string_to_list(s) do
    s
    |> String.replace("\[", "")
    |> String.replace("\]", "")
    |> String.split(", ")
    |> Enum.map(fn x -> String.replace(x, "\"", "") end)
  end

  defp toml_value(s) when is_list(s) do
    toml = Enum.map_join(s, ", ", fn x -> toml_value(x) end)

    "[" <> toml <> "]"
  end

  defp toml_value(s) do
    "\"" <> s <> "\""
  end
end

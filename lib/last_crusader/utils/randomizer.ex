defmodule LastCrusader.Utils.Randomizer do
  @moduledoc """
  Random string generator module.

  Imported from https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7
  """
  @type option() :: :all | :alpha | :numeric | :upcase | :downcase

  @doc """
  Generate random string based on the given length. It is also possible to generate certain type of randomise string
  using the options below:

  * :all - generate alphanumeric random string
  * :alpha - generate nom-numeric random string
  * :numeric - generate numeric random string
  * :upcase - generate upper case non-numeric random string
  * :downcase - generate lower case non-numeric random string

  ## Example
      iex> Iurban.String.randomizer(20) //"Je5QaLj982f0Meb0ZBSK"
  """
  @spec randomizer(pos_integer(), option()) :: String.t()
  def randomizer(length, type \\ :all) do
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numbers = "0123456789"

    cond do
      type == :alpha -> alphabets <> String.downcase(alphabets)
      type == :numeric -> numbers
      type == :upcase -> alphabets
      type == :downcase -> String.downcase(alphabets)
      true -> alphabets <> String.downcase(alphabets) <> numbers
    end
    |> String.split("", trim: true)
    |> do_randomizer(length)
  end

  defp get_range(length) when length > 1, do: 1..length
  defp get_range(_length), do: [1]

  defp do_randomizer(lists, length) do
    get_range(length)
    |> Enum.reduce([], fn _, acc -> [Enum.random(lists) | acc] end)
    |> Enum.join("")
  end
end

defmodule RandomizerTest do
  use ExUnit.Case, async: true

  #alias Randomizer

  test "generate random string" do
    random = Randomizer.randomizer(100)
    assert 100 = String.length(random)
    assert String.match?(random, ~r/[A-Za-z0-9]/)
  end

  test "generate random numbers" do
    random = Randomizer.randomizer(100, :numeric)
    assert 100 = String.length(random)
    refute String.match?(random, ~r/[A-Za-z]/)
  end

  test "generate random upper case" do
    random = Randomizer.randomizer(100, :upcase)
    assert 100 = String.length(random)
    refute String.match?(random, ~r/[a-z0-9]/)
  end

  test "generate random lower case" do
    random = Randomizer.randomizer(100, :downcase)
    assert 100 = String.length(random)
    refute String.match?(random, ~r/[A-Z0-9]/)
  end

  test "generate random alphabets only" do
    random = Randomizer.randomizer(100, :alpha)
    assert 100 = String.length(random)
    refute String.match?(random, ~r/[0-9]/)
  end
end

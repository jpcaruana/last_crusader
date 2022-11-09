defmodule LastCrusader.Utils.TomlTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Utils.Toml, as: Toml

  describe "Toml.update_toml/2" do
    test "add new key/value" do
      toml = """
      key1 = "value1"
      key2 = "value2"
      """

      new_toml = Toml.update_toml(toml, {"key3", "value3"})

      expected_toml = """
      +++
      key1 = "value1"
      key2 = "value2"
      key3 = "value3"
      +++
      """

      assert new_toml == expected_toml
    end

    test "add new key/value (with list)" do
      toml = """
      key1 = "value1"
      key2 = ["value2", "value2"]
      """

      new_toml = Toml.update_toml(toml, {"key3", "value3"})

      expected_toml = """
      +++
      key1 = "value1"
      key2 = ["value2", "value2"]
      key3 = "value3"
      +++
      """

      assert new_toml == expected_toml
    end
  end

  describe "Toml.extract_list/1" do
    test "extract from list" do
      assert ["1", "2"] == Toml.extract_list("[\"1\", \"2\"]")
    end

    test "extract from list: 1 element" do
      assert ["1"] == Toml.extract_list("[\"1\"]")
    end

    test "should be transform non lists to list" do
      assert ["this is not a list, is it?"] == Toml.extract_list("this is not a list, is it?")
    end
  end
end

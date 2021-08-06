defmodule LastCrusader.Utils.TomlTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Utils.Toml, as: Toml

  describe "Update TOML" do
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
end

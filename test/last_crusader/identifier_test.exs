defmodule IdentifierTest do
  use ExUnit.Case, async: true

  test "user profile URL should be valid" do
    assert :valid == IdentifierValidator.validate_user_profile_url("https://example.com/")
    assert :valid == IdentifierValidator.validate_user_profile_url("http://example.com/")
    assert :valid == IdentifierValidator.validate_user_profile_url("https://example.com/username")
    assert :valid == IdentifierValidator.validate_user_profile_url("https://example.com/users?id=100")
  end

  test "these user profile URL are not valid" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("example.com")
    assert :invalid == IdentifierValidator.validate_user_profile_url("mailto:user@example.com")
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://example.com/#me")
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://example.com/foo/../bar")
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://user:pass@example.com/")
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://172.28.92.51/")
  end

end

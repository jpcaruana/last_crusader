defmodule LastCrusader.Utils.IdentifierTest do
  use ExUnit.Case, async: true
  alias LastCrusader.Utils.IdentifierValidator, as: IdentifierValidator

  test "user profile URL should be valid" do
    assert :valid == IdentifierValidator.validate_user_profile_url("https://example.com/")
    assert :valid == IdentifierValidator.validate_user_profile_url("http://example.com/")
    assert :valid == IdentifierValidator.validate_user_profile_url("https://example.com/username")
    assert :valid == IdentifierValidator.validate_user_profile_url("https://example.com/users?id=100")
  end

  test "user profile URL should contain a scheme" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("example.com")
  end
  test "user profile URL scheme should be http or https" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("mailto:user@example.com")
  end
  test "profile URL should not contain a fragment" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://example.com/#me")
  end
  test "profile URL should not contain a double-dot path segment" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://example.com/foo/../bar")
  end
  test "profile URL should not contain a username and password" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://user:pass@example.com/")
  end
  test "profile URL should not be an IP address" do
    assert :invalid == IdentifierValidator.validate_user_profile_url("https://172.28.92.51/")
  end
  test "profile URL should not be nil" do
    assert :invalid == IdentifierValidator.validate_user_profile_url(nil)
  end

end

defmodule IdentifierValidator do
  @moduledoc """
  see spec https://indieauth.spec.indieweb.org/#user-profile-url


  3.1 User Profile URL

  Users are identified by a [URL]. Profile URLs MUST have either an https or http scheme, MUST contain a path component (/ is a valid path), MUST NOT contain single-dot or double-dot path segments, MAY contain a query string component, MUST NOT contain a fragment component, MUST NOT contain a username or password component, and MUST NOT contain a port. Additionally, hostnames MUST be domain names and MUST NOT be ipv4 or ipv6 addresses.

  Some examples of valid profile URLs are:

      https://example.com/
      https://example.com/username
      https://example.com/users?id=100

  Some examples of invalid profile URLs are:

      example.com - missing scheme
      mailto:user@example.com - invalid scheme
      https://example.com/foo/../bar - contains a double-dot path segment
      https://example.com/#me - contains a fragment
      https://user:pass@example.com/ - contains a username and password
      https://example.com:8443/ - contains a port
      https://172.28.92.51/ - host is an IP address
  """

  def validate_user_profile_url(url) do
    URI.parse(url)
    |> validate_profile
  end

  defp validate_profile(%URI{host: nil}), do: :invalid
  defp validate_profile(%URI{scheme: "https", path: path, host: host, userinfo: nil, fragment: nil}),
       do: valid2(path, host)
  defp validate_profile(%URI{scheme: "http", path: path, host: host, userinfo: nil, fragment: nil}),
       do: valid2(path, host)
  defp validate_profile(_), do: :invalid

  defp valid2(path, host) do
    [head | tail] = String.split(path, ["/../"])
    case length(tail) do
      0 -> valid3(host)
      _ -> :invalid
    end
  end

  defp valid3(host) do
    case :inet.parse_address(to_charlist(host)) do
      {:ok, _} -> :invalid
      _ -> :valid
    end
  end
end

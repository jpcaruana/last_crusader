defmodule LastCrusader.Utils.IdentifierValidator do
  @moduledoc """
  Indie Auth Identifier Validator

  see spec https://indieauth.spec.indieweb.org/#user-profile-url

  ## User Profile URL

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
  @type url() :: String.t()

  @doc """
    Validates a user profile URL according to the IndieAuth spec

    Useful in a validation pipe, but really relies on `validate_user_profile_url/1`
  """
  @spec validate_user_profile_url(:invalid | :valid, url()) :: :invalid | :valid
  def validate_user_profile_url(:invalid, _), do: :invalid
  def validate_user_profile_url(:valid, url), do: validate_user_profile_url(url)

  # real validation
  @doc """
    Validates a user profile URL according to the IndieAuth spec
  """
  @spec validate_user_profile_url(url()) :: :invalid | :valid
  def validate_user_profile_url(nil), do: :invalid

  def validate_user_profile_url(url) do
    URI.parse(url)
    |> validate_profile
  end

  defp validate_profile(%URI{host: nil}), do: :invalid

  defp validate_profile(%URI{
         scheme: "https",
         path: path,
         host: host,
         userinfo: nil,
         fragment: nil
       }),
       do:
         validate_path(path)
         |> validate_host(host)

  defp validate_profile(%URI{scheme: "http", path: path, host: host, userinfo: nil, fragment: nil}),
       do:
         validate_path(path)
         |> validate_host(host)

  defp validate_profile(_), do: :invalid

  defp validate_path(path) do
    case String.split(path, ["/../"]) do
      [_ | []] -> :valid
      _ -> :invalid
    end
  end

  defp validate_host(:invalid, _), do: :invalid

  defp validate_host(:valid, host) do
    case :inet.parse_address(to_charlist(host)) do
      {:ok, _} -> :invalid
      _ -> :valid
    end
  end
end

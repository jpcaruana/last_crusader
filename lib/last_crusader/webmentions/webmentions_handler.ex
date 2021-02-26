defmodule LastCrusader.Webmentions.Handler do
  @moduledoc """
     Webmention is a simple way to notify any URL when you mention it on your site. From the receiver's perspective, it's a way to request notifications when other sites mention it.

    A Webmention is a notification that one URL links to another. For example, Alice writes an interesting post on her blog. Bob then writes a response to her post on his own site, linking back to Alice's original post. Bob's publishing software sends a Webmention to Alice notifying that her article was replied to, and Alice's software can show that reply as a comment on the original post.
    
    See specification: https://www.w3.org/TR/webmention/#receiving-webmentions
  """
  import Plug.Conn
  require Logger

  @doc """
  Receives webmentions.

  Upon receipt of a POST request containing the source and target parameters, the receiver SHOULD verify the parameters and then SHOULD queue and process the request asynchronously, to prevent DoS attacks.

  If the receiver processes the request asynchronously but does not return a status URL, the receiver MUST reply with an HTTP 202 Accepted response. The response body MAY contain content, in which case a human-readable response is recommended.
  """
  def receive(conn) do
    with :ok <- check_content_type(conn),
         {:ok, source, target} <- extract_urls(conn) do
      validate(source, target)

      conn
      |> send_resp(202, "Accepted")
    else
      {:error, "unsupported content type"} ->
        conn
        |> send_resp(415, "unsupported content type")

      {:error, reason} ->
        conn
        |> send_resp(400, reason)

      _ ->
        conn
        |> send_resp(400, "bad request")
    end
  end

  defp validate(_source, _target) do
    # Webmentions.discover_endpoint(source_url)
    # {:ok, nil} -> {:ko, "no webmention endpoint found"}
    # {:ok, ""} -> {:ko, "no webmention endpoint found"}
    :ok
  end

  defp check_content_type(conn) do
    with [type] <- Plug.Conn.get_req_header(conn, "content-type"),
         {:ok, "application", "x-www-form-urlencoded", _} <- Plug.Conn.Utils.content_type(type) do
      :ok
    else
      _ ->
        {:error, "unsupported content type"}
    end
  end

  defp extract_urls(%{params: %{"source" => source, "target" => target}}) do
    source = URI.parse(source)
    target = URI.parse(target)

    cond do
      URI.to_string(source) == URI.to_string(target) ->
        {:error, "source and target match"}

      source.scheme not in ["http", "https"] ->
        {:error, "unsupported scheme for source"}

      target.scheme not in ["http", "https"] ->
        {:error, "unsupported scheme for target"}

      true ->
        {:ok, source, target}
    end
  end

  defp extract_urls(%{params: %{"source" => _}}) do
    {:error, "no target specified"}
  end

  defp extract_urls(_) do
    {:error, "no source specified"}
  end
end
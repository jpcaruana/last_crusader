defmodule LastCrusader.Webmentions.Validator do
  @moduledoc """
     Module responsible for webmentions validations
  """

  @type reason() :: String.t()
  @doc """
    Validates source and target URL

    URL should be well formed and with HTTP(s) scheme
  """
  @spec validate_urls(URI.t(), URI.t()) :: {:ok, :valid} | {:error, reason()}
  def validate_urls(%URI{scheme: source_scheme}, _target)
      when source_scheme not in ["http", "https"] do
    {:error, "unsupported scheme for source"}
  end

  def validate_urls(_source, %URI{scheme: target_scheme})
      when target_scheme not in ["http", "https"] do
    {:error, "unsupported scheme for target"}
  end

  def validate_urls(_, _) do
    {:ok, :valid}
  end

  @doc """
    Validates that:
    - source URL really exists
    - source URL contains a reference to target URL
  """
  @spec validate_content(URI.t(), URI.t()) :: {:ok, :valid} | {:error, reason()}
  def validate_content(source_url, target_url) do
    with {:ok, response} <- Tesla.get(source_url),
         {:ok, body} <- success?(:ok, response),
         {:ok, _} <- document_contains_link(body, target_url) do
      {:ok, :valid}
    else
      {:error, 404} ->
        {:error, "source URL not found"}

      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, "unknown error"}
    end
  end

  defp document_contains_link(document, link) do
    links =
      Floki.parse_document!(document)
      |> Floki.find("a")

    if links != nil and
         Floki.attribute(links, "href")
         |> Enum.any?(fn l -> l == URI.to_string(link) end) do
      {:ok, :valid}
    else
      {:error, "source does not contain a link to the target"}
    end
  end

  defp success?(:ok, %Tesla.Env{status: code, body: body}) when code in 200..299 do
    {:ok, body}
  end

  defp success?(:ok, %Tesla.Env{status: code}) do
    {:error, code}
  end

  defp success?(_, _) do
    {:error, :unknown}
  end
end

defmodule LastCrusader.Webmentions.Sender do
  @moduledoc """
  Schedules webmentions to be send

  It first checks of the origin exists before sending webmentions. It will retry this check every minute until it reaches the configured number of tries.
  """
  alias LastCrusader.Micropub
  alias Webmentions
  require Logger
  require Tesla
  alias Jason, as: Json

  @type url() :: String.t()
  @one_minute 60_000

  @doc """
    Schedules webmentions to be send with 1 minute wait between every try (default is 15 times)
  """
  @spec schedule_webmentions(list(url()), url(), pos_integer()) :: {:ok, non_neg_integer()}
  def schedule_webmentions(links, origin, nb_max_tries \\ 15)

  def schedule_webmentions([], origin, _nb_max_tries) do
    Logger.info("No webmentions to send from #{inspect(origin)}")
    {:ok, 0}
  end

  def schedule_webmentions(links, origin, nb_max_tries) do
    do_schedule_webmentions(links, origin, nb_max_tries, 0)
    {:ok, nb_max_tries}
  end

  defp do_schedule_webmentions(links, origin, all_tried, all_tried) do
    Logger.warning(
      "Sending webmentions from #{inspect(origin)} to #{inspect(links)}: aborted (too many tries)"
    )

    {:ok, self(), []}
  end

  defp do_schedule_webmentions(links, origin, nb_max_tries, nb_tried) do
    Logger.info(
      "Sending webmentions from #{inspect(origin)} to #{inspect(links)}: scheduled. try #{inspect(nb_tried)}/#{inspect(nb_max_tries)}"
    )

    Task.async(fn -> start_task(origin, links, nb_max_tries, nb_tried) end)
  end

  defp start_task(origin, links, nb_max_tries, nb_tried) do
    :timer.sleep(@one_minute)

    case Tesla.head(origin) do
      {:ok, %Tesla.Env{status: 200}} ->
        send_webmentions(origin, links, nb_max_tries, nb_tried)

      other ->
        Logger.info("#{inspect(other)}")
        do_schedule_webmentions(links, origin, nb_max_tries, nb_tried + 1)
    end
  end

  @doc """
    Sends Webmentions to every link
  """
  def send_webmentions(origin, links, nb_max_tries \\ 1, nb_tried \\ 0) do
    Logger.info(
      "Sending webmentions from #{inspect(origin)} to #{inspect(links)}: try #{inspect(nb_tried)}/#{inspect(nb_max_tries)}"
    )

    {:ok, webmention_response} = Webmentions.send_webmentions_for_links(origin, links)

    Logger.info("Result: webmentions: #{inspect(webmention_response)}")

    Task.async(fn -> update_content_with_syndication(origin, webmention_response) end)

    {:ok, self(), webmention_response}
  end

  defp update_content_with_syndication(origin, webmention_responses) do
    find_syndication_links(webmention_responses)
    |> update_content(origin)
  end

  @doc """
    Finds syndications links (from bridy to twitter) in a list of Webmentions responses
  """
  def find_syndication_links(webmention_response, syndication_links \\ [])

  def find_syndication_links([], syndication_links) do
    syndication_links
  end

  def find_syndication_links([head | tail], syndication_links) do
    case head do
      %Webmentions.Response{
        status: :ok,
        target: "https://brid.gy/publish/twitter",
        endpoint: "https://brid.gy/publish/webmention",
        message: "sent",
        body: body
      } ->
        find_syndication_links(tail, syndication_links ++ find_syndication_link(body))

      _ ->
        find_syndication_links(tail, syndication_links)
    end
  end

  defp find_syndication_link(body) do
    case Json.decode(body) do
      {:ok, %{"url" => url}} -> [url]
      _ -> []
    end
  end

  @spec update_content(list(url()), url()) :: nil
  defp update_content(syndication_links, origin)

  defp update_content([], origin) do
    Logger.info("No more syndication links found for from #{inspect(origin)}")
  end

  defp update_content([link | _], origin) do
    {:ok, origin} = Micropub.add_keyword_to_post(origin, {"copy", link})
    Logger.info("Syndication link found for from #{inspect(origin)}. Content is up to date")
  end
end

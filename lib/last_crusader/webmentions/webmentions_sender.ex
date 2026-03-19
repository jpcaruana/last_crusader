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
  # one minute is 60 000ms
  @one_minute 60_000

  @doc """
    Schedules webmentions to be send with 1 minute wait between every try (default is 15 times).
    Only sends webmentions to the explicitly provided `syndication_targets`.
  """
  @spec schedule_webmentions(url(), [url()], pos_integer()) :: {:ok, non_neg_integer()}
  def schedule_webmentions(origin, syndication_targets \\ [], nb_max_tries \\ 15)

  def schedule_webmentions(_origin, [], nb_max_tries), do: {:ok, nb_max_tries}

  def schedule_webmentions(origin, syndication_targets, nb_max_tries) do
    do_schedule_webmentions(origin, syndication_targets, nb_max_tries, 0)
    {:ok, nb_max_tries}
  end

  defp do_schedule_webmentions(origin, _syndication_targets, all_tried, all_tried) do
    Logger.warning("Sending webmentions from #{inspect(origin)}: aborted (too many tries)")

    {:ok, self(), []}
  end

  defp do_schedule_webmentions(origin, syndication_targets, nb_max_tries, nb_tried) do
    Logger.info(
      "Sending webmentions from #{inspect(origin)}: scheduled. try #{inspect(nb_tried)}/#{inspect(nb_max_tries)}"
    )

    Enum.each(syndication_targets, fn target ->
      Task.Supervisor.start_child(LastCrusader.TaskSupervisor, fn ->
        start_task(origin, target, nb_max_tries, nb_tried)
      end)
    end)
  end

  defp start_task(origin, syndication_target, nb_max_tries, nb_tried) do
    Logger.info(
      "Started async task for webmentions on #{inspect(origin)}: try #{inspect(nb_tried)}/#{inspect(nb_max_tries)}. Will wait for #{inspect(@one_minute)}ms"
    )

    Process.sleep(@one_minute)

    case Tesla.head(origin) do
      {:ok, %Tesla.Env{status: 200}} ->
        Logger.info("Success on #{inspect(origin)}. I will send webmentions.")
        send_webmentions(origin, [syndication_target])

      {:ok, %Tesla.Env{status: status}} ->
        Logger.info("HEAD on #{inspect(origin)}: HTTP status=#{inspect(status)}")
        do_schedule_webmentions(origin, [syndication_target], nb_max_tries, nb_tried + 1)

      other ->
        Logger.info("HEAD on #{inspect(origin)}: #{inspect(other)}")
        do_schedule_webmentions(origin, [syndication_target], nb_max_tries, nb_tried + 1)
    end
  end

  @doc """
    Sends webmentions to explicitly specified `syndication_targets` only.
    If `syndication_targets` is empty, no webmentions are sent.
  """
  def send_webmentions(origin, []) do
    Logger.info("Sending webmentions from #{inspect(origin)}: no targets, skipping")
    {:ok, self(), []}
  end

  def send_webmentions(origin, syndication_targets) do
    Logger.info("Sending webmentions from #{inspect(origin)}")

    {:ok, webmention_response} =
      Webmentions.send_webmentions_for_links(origin, syndication_targets)

    Enum.each(webmention_response, fn x -> Logger.debug("Result: webmention: #{inspect(x)}") end)

    Task.Supervisor.async_nolink(LastCrusader.TaskSupervisor, fn ->
      update_content_with_syndication(origin, webmention_response)
    end)

    {:ok, self(), webmention_response}
  end

  defp update_content_with_syndication(origin, webmention_responses) do
    find_syndication_links(webmention_responses)
    |> update_content(origin)
  end

  @spec update_content(list(url()), url()) :: nil
  defp update_content(syndication_links, origin)

  defp update_content([], origin) do
    Logger.info("No more syndication links found for from #{inspect(origin)}")
  end

  defp update_content([{link, type} | tail], origin) do
    Logger.info("Updating content with #{inspect(type)} syndication link #{inspect(link)}")
    {:ok, origin} = Micropub.add_keyword_to_post(origin, {type, link})
    Logger.info("Syndication link found for from #{inspect(origin)}. Content is up to date")
    update_content(tail, origin)
  end

  @doc """
    Finds syndication links (from bridy to twitter) in a list of Webmentions responses
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
        find_syndication_links(tail, syndication_links ++ find_syndication_link(body, "twitter"))

      %Webmentions.Response{
        status: :ok,
        target: "https://brid.gy/publish/mastodon",
        endpoint: "https://brid.gy/publish/webmention",
        message: "sent",
        body: body
      } ->
        find_syndication_links(tail, syndication_links ++ find_syndication_link(body, "mastodon"))

      %Webmentions.Response{
        status: :ok,
        target: "https://brid.gy/publish/bluesky",
        endpoint: "https://brid.gy/publish/webmention",
        message: "sent",
        body: body
      } ->
        find_syndication_links(tail, syndication_links ++ find_syndication_link(body, "bluesky"))

      _ ->
        find_syndication_links(tail, syndication_links)
    end
  end

  defp find_syndication_link(body, type) do
    case Json.decode(body) do
      {:ok, %{"url" => url}} ->
        Logger.info("Syndication link (#{inspect(type)}) found: #{inspect(url)}")
        [{url, type}]

      _ ->
        Logger.info("No syndication link found")
        []
    end
  end
end

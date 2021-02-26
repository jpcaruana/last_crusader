defmodule LastCrusader.Webmentions.Sender do
  @moduledoc """
  Schedules webmentions to be send
  """
  alias Webmentions
  require Logger

  def schedule_webmentions(links, origin, duration \\ 900_000)

  def schedule_webmentions([], origin, _duration) do
    Logger.info("No webmentions to send from #{inspect(origin)}")
    {:ok, 0}
  end

  def schedule_webmentions(links, origin, duration) do
    Task.async(fn -> start_task(origin, links, duration) end)
    {:ok, duration}
  end

  defp start_task(origin, links, duration) do
    Logger.info("Sending webmentions from #{inspect(origin)} to #{inspect(links)}: scheduled..")
    :timer.sleep(duration)

    Logger.info("Sending webmentions from #{inspect(origin)} to #{inspect(links)}: start")
    {:ok, sent} = Webmentions.send_webmentions_for_links(origin, links)

    Logger.info("Sending webmentions from #{inspect(origin)} to #{inspect(links)}: done")
    Logger.info("Result: webmentions: #{inspect(sent)}")

    {:ok, self(), sent}
  end
end

defmodule LastCrusader.Handler do
  @moduledoc """
  Handles HTTP requests
  """

  def handle_events(conn) do
    {status, body} =
      case conn.body_params do
        %{"events" => events} -> {200, process_events(events)}
        _ -> {422, missing_events()}
      end

    Plug.Conn.send_resp(conn, status, body)
  end

  defp process_events(events) when is_list(events) do
    # Do some processing on a list of events
    Poison.encode!(%{response: "Received Events!"})
  end
  defp process_events(_) do
    # If we can't process anything, let them know :)
    Poison.encode!(%{response: "Please Send Some Events!"})
  end

  defp missing_events do
    Poison.encode!(%{error: "Expected Payload: { 'events': [...] }"})
  end
end

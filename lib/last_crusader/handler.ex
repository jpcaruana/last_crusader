defmodule LastCrusader.Handler do
  @moduledoc """
  Handles HTTP requests
  """
  import Plug.Conn
  import Poison

  def handle_events(conn) do
    {status, body} =
      case conn.body_params do
        %{"events" => events} -> {200, process_events(events)}
        _ -> {422, missing_events()}
      end

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, body)
  end

  defp process_events(events) when is_list(events) do
    # Do some processing on a list of events
    encode!(%{response: "Received Events!"})
  end
  defp process_events(_) do
    # If we can't process anything, let them know :)
    encode!(%{response: "Please Send Some Events!"})
  end

  defp missing_events do
    encode!(%{error: "Expected Payload: { 'events': [...] }"})
  end
end

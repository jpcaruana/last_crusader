defmodule LastCrusader.ExampleHandler do
  @moduledoc false
  import Plug.Conn
  alias Poison, as: Json

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
    Json.encode!(%{response: "Received Events!"})
  end

  defp process_events(_) do
    # If we can't process anything, let them know :)
    Json.encode!(%{response: "Please Send Some Events!"})
  end

  defp missing_events do
    Json.encode!(%{error: "Expected Payload: { 'events': [...] }"})
  end
end

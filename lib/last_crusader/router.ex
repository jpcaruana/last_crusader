defmodule LastCrusader.Router do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """
  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  # responsible for dispatching responses
  plug(:dispatch)
  # TODO: add routes!

  # Simple GET Request handler for path /hello
  get "/hello" do
    send_resp(conn, 200, "world")
  end

  # Basic example to handle POST requests wiht a JSON body
  post "/post" do
    {:ok, body, conn} = read_body(conn)

    # body = Poison.decode!(body)
    # IO.inspect(body)

    send_resp(conn, 201, Poison.encode!(%{created: "#{get_in(body, ["message"])}"}))
  end

  # from https://dev.to/jonlunsford/elixir-building-a-small-json-endpoint-with-plug-cowboy-and-poison-1826
  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  post "/events" do
    {status, body} =
      case conn.body_params do
        %{"events" => events} -> {200, process_events(events)}
        _ -> {422, missing_events()}
      end

    send_resp(conn, status, body)
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

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end
end

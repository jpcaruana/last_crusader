defmodule LastCrusader.Router do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """
  alias LastCrusader.Auth.AuthHandler, as: Auth
  alias LastCrusader.Login.LoginHandler, as: Login
  alias LastCrusader.Micropub.MicropubHandler, as: Micropub
  use Plug.Router
  use Plug.ErrorHandler

  if Mix.env == :dev do
    use Plug.Debugger
  end

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # Serve at "/" the static files from "priv/static" directory.
  plug Plug.Static,
       at: "/public",
       from: {:last_crusader, "priv/static"}
  # responsible for matching routes
  plug(:match)

  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  #plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug Plug.Parsers,
       parsers: [:urlencoded, :json],
       pass: ["text/*"],
       json_decoder: Poison
  # responsible for dispatching responses
  plug(:dispatch)

  # from https://dev.to/jonlunsford/elixir-building-a-small-json-endpoint-with-plug-cowboy-and-poison-1826
  # A simple route to test that the server is up
  get "/ping" do
    send_resp(conn, 200, "pong!")
  end
  post "/events" do
    LastCrusader.ExampleHandler.handle_events(conn)
  end


  get "/auth" do
    Auth.auth_endpoint(conn)
  end
  post "/auth" do
    Auth.code_verification(conn)
  end

  get "/callback" do
    conn
    |> put_resp_content_type("text/html; charset=utf-8")
    |> send_resp(200, "<html><body>Dans le callback</body></html>")
  end

  post "/login" do
    Login.log_user(conn)
  end

  post "/micropub" do
    Micropub.publish(conn)
  end

  get "/favicon.ico" do
    send_resp(conn, 204, "")
  end
  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end

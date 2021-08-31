defmodule LastCrusader.Router do
  @moduledoc false
  alias LastCrusader.Auth.AuthHandler, as: Auth
  alias LastCrusader.Micropub.MicropubHandler, as: Micropub
  alias LastCrusader.Webmentions.Handler, as: Webmentions
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  if Application.compile_env(:last_crusader, :env) == :dev do
    use Plug.Debugger
  end

  # Using Plug.Logger for logging request information
  if Application.compile_env(:last_crusader, :plug_logger, true) do
    plug(Plug.Logger)
  end

  plug(Plug.RequestId)

  # see https://hexdocs.pm/plug/Plug.RewriteOn.html
  plug(Plug.RewriteOn, [:x_forwarded_host, :x_forwarded_port, :x_forwarded_proto])

  # Serve at "/public" the static files from "priv/static" directory.
  # plug(Plug.Static,
  #  at: "/public",
  #  from: {:last_crusader, "priv/static"}
  # )

  # responsible for matching routes
  plug(:match)

  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  # plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  # sentry
  plug(Sentry.PlugContext)

  # responsible for dispatching responses
  plug(:dispatch)

  get "/status" do
    send_resp(conn, 200, "OK")
  end

  get "/auth" do
    Auth.auth_endpoint(conn)
  end

  post "/auth" do
    Auth.code_verification(conn)
  end

  get "/micropub" do
    Micropub.query(conn)
  end

  post "/micropub" do
    Micropub.publish(conn)
  end

  post "/comment" do
    Micropub.comment(conn)
  end

  options "/comment" do
    Micropub.options_comment(conn)
  end

  post "/webmention" do
    Webmentions.receive(conn)
  end

  get "/favicon.ico" do
    send_resp(conn, 204, "")
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: _stack}) do
    Logger.error("Error on request: #{inspect(kind)} / : #{inspect(reason)}")
    error_message =
      if Mix.env() in ["test", "dev"] do
        "Something went wrong: #{inspect(kind)} / #{inspect(reason)}}"
      else
        "Something went wrong"
      end

    send_resp(conn, conn.status, error_message)
  end
end

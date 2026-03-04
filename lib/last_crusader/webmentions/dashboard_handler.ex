defmodule LastCrusader.Webmentions.DashboardHandler do
  @moduledoc false
  import Ecto.Query
  alias LastCrusader.Repo
  alias LastCrusader.Webmentions.ReceivedWebmention
  import Plug.Conn

  @doc "Handles GET /webmentions: authenticates via token, renders all received webmentions as HTML."
  @spec show(Plug.Conn.t()) :: Plug.Conn.t()
  def show(conn) do
    token = conn.query_params["token"]
    expected = Application.get_env(:last_crusader, :webmention_viewer_token)

    if token != nil and Plug.Crypto.secure_compare(token, expected) do
      records =
        Repo.all(from(r in ReceivedWebmention, order_by: [desc: r.inserted_at]))

      html = render(records)

      conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, html)
    else
      send_resp(conn, 401, "Unauthorized")
    end
  end

  defp render(records) do
    rows =
      Enum.map_join(records, "\n", fn r ->
        """
        <tr>
          <td>#{escape(r.source)}</td>
          <td>#{escape(r.target)}</td>
          <td>#{escape(r.status)}</td>
          <td>#{r.inserted_at}</td>
        </tr>
        """
      end)

    """
    <!DOCTYPE html>
    <html>
    <head><title>Received Webmentions</title></head>
    <body>
    <h1>Received Webmentions</h1>
    <table>
      <thead>
        <tr><th>Source</th><th>Target</th><th>Status</th><th>Date</th></tr>
      </thead>
      <tbody>
    #{rows}
      </tbody>
    </table>
    </body>
    </html>
    """
  end

  defp escape(nil), do: ""

  defp escape(str) do
    str
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
  end
end

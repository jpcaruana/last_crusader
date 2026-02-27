defmodule LastCrusader.Webmentions.ReceiverHandler do
  @moduledoc false
  alias LastCrusader.Webmentions.Receiver
  import Plug.Conn

  @doc "Handles POST /webmention: validates source/target, stores a pending record, triggers async verification."
  @spec receive_webmention(Plug.Conn.t()) :: Plug.Conn.t()
  def receive_webmention(conn) do
    source = conn.body_params["source"]
    target = conn.body_params["target"]

    if valid_url?(source) and valid_url?(target) do
      {:ok, id} = Receiver.accept(source, target)

      Task.Supervisor.async_nolink(LastCrusader.TaskSupervisor, fn ->
        Receiver.verify(id, source, target)
      end)

      send_resp(conn, 202, "Accepted")
    else
      send_resp(conn, 400, "Bad Request: source and target are required HTTP URLs")
    end
  end

  defp valid_url?(nil), do: false
  defp valid_url?(""), do: false

  defp valid_url?(url) do
    case URI.parse(url) do
      %URI{scheme: scheme} when scheme in ["http", "https"] -> true
      _ -> false
    end
  end
end

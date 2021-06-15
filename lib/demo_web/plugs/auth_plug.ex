defmodule Demo.AuthPlug do
  require Logger
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # Placed here by authentication plug
    with true <- Map.has_key?(conn.assigns, :user_id),
         true <-
           has_permissions?(
             conn.assigns[:user_id],
             # This is less than ideal
             Map.get(conn.private, :phoenix_live_view),
             conn
           ) do
      conn
    else
      _ -> auth_error!(conn)
    end
  end

  defp auth_error!(conn) do
    conn
    |> put_status(403)
    |> put_resp_content_type("text/html")
    |> send_resp(
      403,
      Phoenix.View.render_to_string(Demo.ErrorView, "403.html", %{conn: conn})
    )
    |> halt
  end

  # If no live view, skip
  defp has_permissions?(_, live_view, _) when is_nil(live_view), do: true

  # Check live_view module for authorized result
  defp has_permissions?(user_id, {module, _}, conn) do
    apply(module, :authorized?, [user_id, conn.params, get_session(conn)])
  end
end

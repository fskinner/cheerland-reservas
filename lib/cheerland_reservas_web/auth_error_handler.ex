defmodule CheerlandReservasWeb.Guardian.AuthErrorHandler do
  import CheerlandReservasWeb.Router.Helpers

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You must be signed in to access that page.")
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end

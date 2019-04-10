defmodule CheerlandReservasWeb.Guardian.AuthErrorHandler do
  import CheerlandReservasWeb.Router.Helpers

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Você precisa fazer login para acessar esta página.")
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end

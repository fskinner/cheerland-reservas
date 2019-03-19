defmodule CheerlandReservasWeb.Helpers.Auth do
  alias CheerlandReservasWeb.Guardian

  def signed_in?(conn) do
    Guardian.Plug.authenticated?(conn)
  end
end

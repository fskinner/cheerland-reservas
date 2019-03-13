defmodule CheerlandReservasWeb.CurrentUserPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    current_user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end

defmodule CheerlandReservasWeb.PageController do
  use CheerlandReservasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

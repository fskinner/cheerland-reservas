defmodule CheerlandReservasWeb.PageControllerTest do
  use CheerlandReservasWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Cheerland Reservas!"
  end
end

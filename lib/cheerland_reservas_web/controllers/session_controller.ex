defmodule CheerlandReservasWeb.SessionController do
  use CheerlandReservasWeb, :controller

  alias CheerlandReservas.Authentication
  alias CheerlandReservas.Authentication.User
  alias CheerlandReservasWeb.ErrorView
  alias CheerlandReservasWeb.Guardian

  plug(:scrub_params, "user" when action in [:create])

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => params}) do
    user = Authentication.get_user_by_email(params["email"])

    case Bcrypt.check_pass(user, params["password"]) do
      {:ok, user} ->
        conn
        |> signin(user)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "username/password mismatch")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> signout
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp signin(conn, user) do
    conn |> Guardian.Plug.sign_in(user)
  end

  defp signout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end

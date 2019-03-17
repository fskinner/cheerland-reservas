defmodule CheerlandReservasWeb.SessionController do
  use CheerlandReservasWeb, :controller

  alias CheerlandReservas.Authentication
  alias CheerlandReservas.Authentication.User
  alias CheerlandReservasWeb.ErrorView

  plug(:scrub_params, "user" when action in [:create])

  action_fallback(CheerlandReservasWeb.FallbackController)

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => params}) do
    user = Authentication.get_user_by_email(params["email"])

    case Bcrypt.check_pass(user, params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_session(:current_user_name, user.name)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        IO.puts("FAILS")

        conn
        |> put_flash(:error, "username/password mismatch")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    # |> delete_session(:current_user_name)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

defmodule CheerlandReservasWeb.UserController do
  use CheerlandReservasWeb, :controller

  alias CheerlandReservas.Authentication
  alias CheerlandReservas.Authentication.User

  def new(conn, _params) do
    changeset = Authentication.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Authentication.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end

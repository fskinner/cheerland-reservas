defmodule CheerlandReservasWeb.UserController do
  use CheerlandReservasWeb, :controller

  alias CheerlandReservas.Authentication
  alias CheerlandReservas.Authentication.User

  plug(:scrub_params, "user" when action in [:create])

  def index(conn, _params) do
    users = Authentication.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Authentication.get_user!(id)
    render(conn, "show.html", user: user)
  end

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
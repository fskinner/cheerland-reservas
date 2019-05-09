defmodule CheerlandReservasWeb.UserController do
  use CheerlandReservasWeb, :controller
  # use CheerlandReservasWeb.BaseController

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
      {:ok, _} ->
        conn
        |> put_flash(:info, "Usuário criado.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Authentication.get_user!(id)
    changeset = Authentication.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Authentication.get_user!(id)

    case Authentication.patch_update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Informações de transporte salvas!")
        |> redirect(to: Routes.room_path(conn, :show, user.room_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end

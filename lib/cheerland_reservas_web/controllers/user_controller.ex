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
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def csv_report(conn, _params) do
    users = Authentication.list_users()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"cheerland-reservas.csv\"")
    |> send_resp(200, csv_content(users))
  end

  defp csv_content(users) do
    csv_content =
      users
      |> parse_user
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string
  end

  defp parse_user(users) do
    headers = [~w(Nome Email Sexo Transporte LocalOnibus HorarioOnibus HorarioRetorno Quarto)]

    parsed_users =
      users
      |> Enum.map(fn x ->
        [
          x.name,
          x.email,
          x.gender,
          "#{x.needs_transportation}",
          x.departure_location || "-",
          x.departure_time || "-",
          x.return_time || "-",
          x.room_id || "-"
        ]
      end)

    Enum.concat(headers, parsed_users)
  end
end

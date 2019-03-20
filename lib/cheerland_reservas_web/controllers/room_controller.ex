defmodule CheerlandReservasWeb.RoomController do
  use CheerlandReservasWeb, :controller
  use CheerlandReservasWeb.BaseController

  alias CheerlandReservas.Reservations
  alias CheerlandReservas.Reservations.Room

  def index(conn, _params, current_user) do
    rooms = Reservations.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params, current_user) do
    changeset = Reservations.change_room(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}, current_user) do
    case Reservations.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    room = Reservations.get_room!(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}, current_user) do
    room = Reservations.get_room!(id)
    changeset = Reservations.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}, current_user) do
    room = Reservations.get_room!(id)

    case Reservations.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    room = Reservations.get_room!(id)
    {:ok, _room} = Reservations.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end

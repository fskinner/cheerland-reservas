defmodule CheerlandReservas.Reservations do
  @moduledoc """
  The Reservations context.
  """

  import Ecto.Query, warn: false
  alias CheerlandReservas.Repo

  alias CheerlandReservas.Reservations.Room
  alias CheerlandReservas.Authentication.User
  alias CheerlandReservas.Authentication

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room) |> Repo.preload(:users)
  end

  @doc """
  Gets a single room with its users.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id) do
    Repo.get!(Room, id) |> Repo.preload(:users)
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  defp check_user_reservation(room_id) when is_nil(room_id), do: {:ok}
  defp check_user_reservation(_), do: {:error, "You already reserved a room"}

  defp check_room_availability(room) do
    cond do
      length(room.users) == room.max_beds -> {:error, "Room is full"}
      length(room.users) < room.max_beds -> {:ok}
    end
  end

  defp handle_error({:error, payload}) when is_bitstring(payload), do: {:error, payload}

  defp handle_error({:error, payload}) when not is_bitstring(payload),
    do: {:error, "Couldn't book room"}

  @doc """
  Books a Room.

  ## Examples

      iex> book_room(1, 2)
      {:ok}

      iex> book_room(2, 2)
      {:error, "Error message"}

  """
  def book_room(id, user_id) do
    user = Authentication.get_user!(user_id)
    room = get_room!(id)

    with {:ok} <- check_user_reservation(user.room_id),
         {:ok} <- check_room_availability(room),
         {:ok, _} <- Authentication.patch_update_user(user, %{room_id: id}) do
      {:ok}
    else
      {:error, payload} -> handle_error({:error, payload})
    end
  end
end

defmodule CheerlandReservas.ReservationsTest do
  use CheerlandReservas.DataCase

  alias CheerlandReservas.Reservations

  describe "rooms" do
    alias CheerlandReservas.Reservations.Room

    @valid_attrs %{beds: 42, label: "some label", women_only: true}
    @update_attrs %{beds: 43, label: "some updated label", women_only: false}
    @invalid_attrs %{beds: nil, label: nil, women_only: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reservations.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Reservations.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Reservations.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Reservations.create_room(@valid_attrs)
      assert room.beds == 42
      assert room.label == "some label"
      assert room.women_only == true
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reservations.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Reservations.update_room(room, @update_attrs)
      assert room.beds == 43
      assert room.label == "some updated label"
      assert room.women_only == false
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Reservations.update_room(room, @invalid_attrs)
      assert room == Reservations.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Reservations.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Reservations.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Reservations.change_room(room)
    end
  end
end

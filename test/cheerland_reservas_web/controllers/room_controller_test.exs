defmodule CheerlandReservasWeb.RoomControllerTest do
  use CheerlandReservasWeb.ConnCase

  import CheerlandReservas.Factory

  alias CheerlandReservas.Reservations
  alias CheerlandReservasWeb.Guardian

  @create_attrs %{max_beds: 42, label: "some label", women_only: true}
  @update_attrs %{max_beds: 43, label: "some updated label", women_only: false}
  @invalid_attrs %{max_beds: nil, label: nil, women_only: nil}

  def fixture(:room) do
    {:ok, room} = Reservations.create_room(@create_attrs)
    room
  end

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> Plug.Test.init_test_session(%{})
      |> Guardian.Plug.sign_in(%{id: user.id, is_admin: true})
      |> Plug.Conn.assign(:current_user, user)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, Routes.room_path(conn, :index))
      assert html_response(conn, 200) =~ "Lista dos Quartos"
    end
  end

  describe "new room" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.room_path(conn, :new))
      assert html_response(conn, 200) =~ "Novo Quarto"
    end
  end

  describe "create room" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.room_path(conn, :show, id)

      conn = get(conn, Routes.room_path(conn, :show, id))
      assert html_response(conn, 200) =~ @create_attrs.label
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @invalid_attrs)
      assert html_response(conn, 200) =~ "Novo Quarto"
    end
  end

  describe "edit room" do
    setup [:create_room]

    test "renders form for editing chosen room", %{conn: conn, room: room} do
      conn = conn |> Plug.Test.init_test_session(%{}) |> get(Routes.room_path(conn, :edit, room))
      assert html_response(conn, 200) =~ "Editar Quarto"
    end
  end

  describe "update room" do
    setup [:create_room]

    test "redirects when data is valid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @update_attrs)
      assert redirected_to(conn) == Routes.room_path(conn, :show, room)

      conn = get(conn, Routes.room_path(conn, :show, room))
      assert html_response(conn, 200) =~ "some updated label"
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editar Quarto"
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete(conn, Routes.room_path(conn, :delete, room))
      assert redirected_to(conn) == Routes.room_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.room_path(conn, :show, room))
      end)
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    {:ok, room: room}
  end
end

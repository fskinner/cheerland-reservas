defmodule CheerlandReservasWeb.UserControllerTest do
  use CheerlandReservasWeb.ConnCase

  import CheerlandReservas.Factory

  alias CheerlandReservas.Authentication
  alias CheerlandReservasWeb.Guardian

  @create_attrs %{
    email: "some@email.com",
    password: "somepassword",
    gender: "some gender",
    name: "some name",
    needs_transportation: true,
    reserved_at: ~D[2010-04-17]
  }
  @invalid_attrs %{
    email: nil,
    password: nil,
    gender: nil,
    name: nil,
    needs_transportation: nil,
    reserved_at: nil
  }

  def fixture(:user) do
    {:ok, user} = Authentication.create_user(@create_attrs)
    user
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
    test "lists all users when logged in", %{conn: conn} do
      conn =
        conn
        |> get(Routes.user_path(conn, :index))

      assert html_response(conn, 200) =~ "Lista de Usuarios"
    end

    test "gets redirect when logged out", %{conn: conn} do
      conn =
        conn
        |> Guardian.Plug.sign_out()
        |> get(Routes.user_path(conn, :index))

      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "get" do
    test "gets user info", %{conn: conn} do
      user = conn.assigns[:current_user]

      conn =
        conn
        |> get(Routes.user_path(conn, :show, user))

      assert html_response(conn, 200) =~ user.name
      assert html_response(conn, 200) =~ user.email
    end

    test "gets redirect when logged out", %{conn: conn} do
      user = conn.assigns[:current_user]

      conn =
        conn
        |> Guardian.Plug.sign_out()
        |> get(Routes.user_path(conn, :show, user))

      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Novo Usuario"
    end
  end

  describe "create" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn = conn |> get(Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ @create_attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Novo Usuario"
    end
  end

  describe "edit" do
    test "renders form for editing chosen user", %{conn: conn} do
      user = conn.assigns[:current_user]

      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Informações do Check-in (Ida)"
      assert html_response(conn, 200) =~ "Informações do Check-out (Volta)"
    end

    test "gets redirect when logged out", %{conn: conn} do
      user = conn.assigns[:current_user]

      conn =
        conn
        |> Guardian.Plug.sign_out()
        |> get(Routes.user_path(conn, :edit, user))

      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "update" do
    test "redirects when data is valid", %{conn: conn} do
      user = conn.assigns[:current_user]

      conn =
        put(conn, Routes.user_path(conn, :update, user),
          user: %{departure_location: "New Location"}
        )

      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "Informações de transporte salvas!"
    end

    test "gets redirect when logged out", %{conn: conn} do
      user = conn.assigns[:current_user]

      conn =
        conn
        |> Guardian.Plug.sign_out()
        |> put(Routes.user_path(conn, :update, user),
          user: %{departure_location: "New Location"}
        )

      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end
end

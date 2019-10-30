defmodule CheerlandReservas.AuthenticationTest do
  use CheerlandReservas.DataCase

  alias CheerlandReservas.Authentication

  describe "users" do
    alias CheerlandReservas.Authentication.User

    @valid_attrs %{
      email: "some@email.com",
      password: "somepassword",
      gender: "some gender",
      name: "some name",
      needs_transportation: true,
      reserved_at: ~D[2010-04-17],
      is_admin: false
    }
    @update_attrs %{
      email: "someupdated@email.com",
      password: "someupdatedpassword",
      gender: "some updated gender",
      name: "some updated name",
      needs_transportation: false,
      reserved_at: ~D[2011-05-18],
      is_admin: false
    }
    @invalid_attrs %{
      email: nil,
      password: nil,
      gender: nil,
      name: nil,
      needs_transportation: nil,
      reserved_at: nil,
      is_admin: false
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authentication.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()

      assert Authentication.list_users() ==
               [user] |> Enum.map(fn x -> x |> Map.put(:password, nil) end)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Authentication.get_user!(user.id) == user |> Map.put(:password, nil)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authentication.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.password == "somepassword"
      assert user.encrypted_password != nil
      assert user.gender == "some gender"
      assert user.name == "some name"
      assert user.needs_transportation == true
      assert user.reserved_at == ~D[2010-04-17]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Authentication.update_user(user, @update_attrs)
      assert user.email == "someupdated@email.com"
      assert user.password == "someupdatedpassword"
      assert user.gender == "some updated gender"
      assert user.name == "some updated name"
      assert user.needs_transportation == false
      assert user.reserved_at == ~D[2011-05-18]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_user(user, @invalid_attrs)
      assert Authentication.get_user!(user.id) == user |> Map.put(:password, nil)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Authentication.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Authentication.change_user(user)
    end
  end
end

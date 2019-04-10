defmodule CheerlandReservas.Authentication.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheerlandReservas.Reservations.Room

  schema "users" do
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:gender, :string)
    field(:name, :string)
    field(:needs_transportation, :boolean, default: false)
    field(:departure_location, :string)
    field(:departure_time, :string)
    field(:return_time, :string)
    field(:is_admin, :boolean, default: false)
    field(:reserved_at, :date)

    belongs_to(:room, Room)

    field(:password, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :name,
      :password,
      :gender,
      :reserved_at,
      :needs_transportation,
      :room_id,
      :is_admin
    ])
    |> validate_required([
      :email,
      :name,
      :password,
      :gender,
      :needs_transportation
    ])
    |> validate_length(:email, min: 5, max: 150)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email, message: "Email already taken")
    |> assoc_constraint(:room)
    |> put_encrypted_password
  end

  @doc false
  def patch_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :reserved_at,
      :needs_transportation,
      :departure_location,
      :departure_time,
      :return_time,
      :room_id
    ])
    |> assoc_constraint(:room)
  end

  defp put_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end

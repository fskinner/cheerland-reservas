defmodule CheerlandReservas.Authentication.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:gender, :string)
    field(:name, :string)
    field(:needs_transportation, :boolean, default: false)
    field(:reserved_at, :date)

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
      :needs_transportation
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
    |> put_encrypted_password
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

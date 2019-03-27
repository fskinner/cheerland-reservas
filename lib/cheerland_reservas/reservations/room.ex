defmodule CheerlandReservas.Reservations.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field(:max_beds, :integer)
    field(:label, :string)
    field(:women_only, :boolean, default: false)

    has_many(:users, CheerlandReservas.Authentication.User)

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:label, :max_beds, :women_only])
    |> validate_required([:label, :max_beds, :women_only])
    |> unique_constraint(:label)
  end
end

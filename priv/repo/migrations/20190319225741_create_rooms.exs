defmodule CheerlandReservas.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :label, :string
      add :beds, :integer
      add :women_only, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:rooms, [:label])
  end
end

defmodule CheerlandReservas.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add(:label, :string)
      add(:description, :string)
      add(:max_beds, :integer)
      add(:women_only, :boolean, default: false, null: false)
      add(:group, :string)
      add(:photos_url, :string)

      timestamps()
    end

    create(unique_index(:rooms, [:label]))
  end
end

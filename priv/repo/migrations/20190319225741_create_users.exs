defmodule CheerlandReservas.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:name, :string)
      add(:encrypted_password, :string)
      add(:gender, :string)
      add(:reserved_at, :date)
      add(:needs_transportation, :boolean, default: false, null: false)
      add(:departure_location, :string)
      add(:departure_time, :string)
      add(:return_time, :string)
      add(:is_admin, :boolean, default: false, null: false)
      add(:room_id, references(:rooms, on_delete: :nothing))
      add(:allowed_group, :integer)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end

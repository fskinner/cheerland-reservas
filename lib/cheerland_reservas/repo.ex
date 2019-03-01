defmodule CheerlandReservas.Repo do
  use Ecto.Repo,
    otp_app: :cheerland_reservas,
    adapter: Ecto.Adapters.Postgres
end

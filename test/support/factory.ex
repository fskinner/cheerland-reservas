defmodule CheerlandReservas.Factory do
  use ExMachina.Ecto, repo: CheerlandReservas.Repo

  def room_factory do
    %CheerlandReservas.Reservations.Room{
      max_beds: 1,
      label: "Random Room",
      women_only: false
    }
  end

  def user_factory do
    %CheerlandReservas.Authentication.User{
      email: "random@mail.com",
      encrypted_password: "LhrP26FFGnMNLdDDtMKiLdw62Wt",
      gender: "M",
      name: "John Doe",
      needs_transportation: true,
      departure_location: "Location X",
      departure_time: "Departure Time Chosen",
      return_time: "Chosen Return",
      is_admin: true,
      reserved_at: DateTime.utc_now(),
      room: build(:room)
    }
  end
end

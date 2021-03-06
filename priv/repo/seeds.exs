# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
CheerlandReservas.Authentication.create_user(%{
  email: "lucasavilez@gmail.com",
  name: "Lucas Avilez",
  password: "a12345A",
  gender: "Masculino",
  is_admin: true,
  allowed_group: "A",
  allow_couple_bed: false
})

CheerlandReservas.Authentication.create_user(%{
  email: "felipeskinner@gmail.com",
  name: "Felipe Skinner",
  password: "a12345A",
  gender: "Masculino",
  is_admin: true,
  allowed_group: "B",
  allow_couple_bed: true
})

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

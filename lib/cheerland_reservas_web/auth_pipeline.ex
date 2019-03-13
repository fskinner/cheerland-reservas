defmodule CheerlandReservasWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :cheerland_reservas,
    module: CheerlandReservasWeb.Guardian,
    error_handler: CheerlandReservasWeb.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)

  # check this afterwards
  plug(Guardian.Plug.LoadResource)
end

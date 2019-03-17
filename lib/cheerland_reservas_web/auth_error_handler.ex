defmodule CheerlandReservasWeb.Guardian.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    errors =
      case type do
        :unauthenticated -> %{message: :forbidden, code: 403}
        _ -> %{message: :internal_server_error, code: 500}
      end

    body = %{errors: %{detail: to_string(errors.message)}}

    conn
    |> put_flash(:error, body)
  end
end

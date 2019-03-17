defmodule CheerlandReservasWeb.Router do
  use CheerlandReservasWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :browser_auth do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(CheerlandReservasWeb.Guardian.AuthPipeline)
    plug(CheerlandReservasWeb.CurrentUserPlug)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", CheerlandReservasWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/registrations", UserController, only: [:create, :new])

    get("/sign-in", SessionController, :new)
    post("/sign-in", SessionController, :create)
  end

  scope "/", CheerlandReservasWeb do
    pipe_through(:browser_auth)

    resources("/users", UserController)
    delete("/sign-out", SessionController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CheerlandReservasWeb do
  #   pipe_through :api
  # end
end

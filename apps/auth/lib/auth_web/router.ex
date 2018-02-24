defmodule AuthWeb.Router do
  use AuthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuthWeb do
    pipe_through :api

    resources "/tokens", TokenController, only: [:create]
  end
end

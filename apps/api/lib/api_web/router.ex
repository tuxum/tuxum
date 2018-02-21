defmodule APIWeb.Router do
  use APIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", APIWeb do
    pipe_through :api
  end
end

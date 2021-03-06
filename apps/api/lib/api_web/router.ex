defmodule APIWeb.Router do
  use APIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug APIWeb.ContextPlug
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: APIWeb.Schema, json_codec: Jason
  end
end

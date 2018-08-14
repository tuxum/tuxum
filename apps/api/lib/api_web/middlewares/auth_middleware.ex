defmodule APIWeb.AuthMiddleware do
  @behaviour Absinthe.Middleware

  @impl Absinthe.Middleware
  def call(resolution, _config) do
    case resolution.context do
      %{current_owner: nil} ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthorized"})

      _ ->
        resolution
    end
  end
end

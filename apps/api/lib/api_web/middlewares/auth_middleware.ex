defmodule APIWeb.AuthMiddleware do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: nil} ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthorized"})
      _ ->
        resolution
    end
  end
end

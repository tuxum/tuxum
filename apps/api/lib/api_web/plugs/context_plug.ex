defmodule APIWeb.ContextPlug do
  @behaviour Plug

  import Plug.Conn

  defmodule Context do
    defstruct [current_user: nil]
  end

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    %Context{}
    |> build_auth_context(conn)
    |> Map.from_struct()
  end

  defp build_auth_context(context, conn) do
    with ["Bearer " <> token | _] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Core.Identities.user_from_token(token) do
      %{context | current_user: user}
    else
      _ -> context
    end
  end
end

defmodule APIWeb.ContextPlug do
  @behaviour Plug

  import Plug.Conn

  defmodule Context do
    defstruct [current_user: nil, current_shop: nil]
  end

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    %Context{}
    |> build_auth_context(conn)
    |> build_shop_context(conn)
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

  defp build_shop_context(context, _conn) do
    with user when user != nil <- context.current_user,
         {:ok, shop} <- Core.Shops.find_shop(context.current_user) do
      %{context | current_shop: shop}
    else
      _ -> context
    end
  end
end

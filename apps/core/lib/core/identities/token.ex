defmodule Core.Identities.Token do
  def to_user(token) do
    token
    |> Joken.token
    |> Joken.with_validation("exp", &(&1 > Joken.current_time))
    |> Joken.with_signer(Joken.hs512(secret()))
    |> Joken.verify
    |> Joken.get_claims
    |> claim_to_user()
  end

  def from_user(user) do
    a_month_later = Joken.current_time + (60 * 60 * 24 * 30)

    %{user_id: user.id}
    |> Joken.token
    |> Joken.with_exp(a_month_later)
    |> Joken.with_signer(Joken.hs512(secret()))
    |> Joken.sign
    |> Joken.get_compact
  end

  defp claim_to_user(%{"user_id" => user_id}) do
    Core.Identities.find_user(%{id: user_id})
  end

  defp claim_to_user(_) do
    nil
  end

  defp secret do
    Application.get_env(:core, :jwt_secret)
  end
end

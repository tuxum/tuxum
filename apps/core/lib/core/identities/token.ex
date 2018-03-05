defmodule Core.Identities.Token do
  def to_owner(token) do
    token
    |> Joken.token
    |> Joken.with_validation("exp", &(&1 > Joken.current_time))
    |> Joken.with_signer(Joken.hs512(secret()))
    |> Joken.verify
    |> Joken.get_claims
    |> claim_to_owner()
  end

  def from_owner(owner) do
    a_month_later = Joken.current_time + (60 * 60 * 24 * 30)

    %{owner_id: owner.id}
    |> Joken.token
    |> Joken.with_exp(a_month_later)
    |> Joken.with_signer(Joken.hs512(secret()))
    |> Joken.sign
    |> Joken.get_compact
  end

  defp claim_to_owner(%{"owner_id" => owner_id}) do
    case Core.Identities.find_owner(%{id: owner_id}) do
      {:ok, owner} -> owner
      _ -> nil
    end
  end

  defp claim_to_owner(_) do
    nil
  end

  defp secret do
    Application.get_env(:core, :jwt_secret)
  end
end

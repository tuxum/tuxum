defmodule Core.DataCase do
  use ExUnit.CaseTemplate

  setup tags do
    Enum.each(DB.repos(), fn repo ->
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(repo)

      unless tags[:async] do
        Ecto.Adapters.SQL.Sandbox.mode(repo, {:shared, self()})
      end
    end)
  end
end

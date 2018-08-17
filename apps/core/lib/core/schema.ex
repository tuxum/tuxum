defmodule Core.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @derive {Phoenix.Param, key: :id}

      @behaviour Core.Schema
    end
  end

  @callback insert_changeset(struct(), map()) :: Ecto.Changeset.t()
  @callback update_changeset(struct(), map()) :: Ecto.Changeest.t()
end

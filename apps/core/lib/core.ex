defmodule Core do
  defmacro __using__(_) do
    quote do
      import Ecto
      import Ecto.Query

      import Core.Helpers
    end
  end

  def insert(struct = %module{}, attrs) do
    struct
    |> module.insert_changeset(attrs)
    |> DB.primary().insert()
  end

  def update(struct = %module{}, attrs) do
    struct
    |> module.update_changeset(attrs)
    |> DB.primary().update()
  end
end

defmodule Core do
  defmacro __using__(_) do
    quote do
      import Ecto
      import Ecto.Query

      import Core.Helpers
    end
  end
end

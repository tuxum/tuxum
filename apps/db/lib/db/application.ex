defmodule DB.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = Enum.map(DB.repos(), fn repo -> {repo, []} end)

    opts = [strategy: :one_for_one, name: DB.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

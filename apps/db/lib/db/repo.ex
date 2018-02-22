defmodule DB.Repo do
  @moduledoc """
  Repository module for the primary database thet handles write operations.
  """

  use Ecto.Repo, otp_app: :db
end

defmodule DBTest do
  use ExUnit.Case, async: true

  test "primary/0" do
    assert DB.primary() == DB.Repo
  end

  test "replica/0" do
    assert DB.replica() == DB.Repo
  end

  test "repos/0" do
    assert DB.repos() |> is_list()
  end
end

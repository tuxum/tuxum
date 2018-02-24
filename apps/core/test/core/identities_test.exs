defmodule Core.IdentitiesTest do
  use Core.DataCase, async: true

  alias Core.Identities

  describe "find_user/1" do
    @params %{
      name: "John Doe",
      email: "john@doe.com",
      password: "s3cr3tp@ssw0rd"
    }

    setup do
      Identities.insert_user(@params)
    end

    test "returns a user by email", %{user: user} do
      assert Identities.find_user(%{email: user.email})
      assert Identities.find_user(%{id: user.id})
    end
  end

  describe "insert_user/1" do
    @params %{
      name: "John Doe",
      email: "john@doe.com",
      password: "s3cr3tp@ssw0rd"
    }

    test "inserts a user and the identity" do
      {:ok, %{user: user, password_identity: _}} = Identities.insert_user(@params)

      assert user.name == @params.name
      assert user.email == @params.email
    end

    test "requires a name" do
      params = %{@params | name: ""}

      assert {:error, :user, _, _} = Identities.insert_user(params)
    end

    test "reqiures a email" do
      params = %{@params | email: ""}

      assert {:error, :user, _, _} = Identities.insert_user(params)
    end

    test "validates email format" do
      ~w[
        valid@email.com
        thisis+valid@email.com
      ]
      |> Enum.each(fn email ->
        params = %{@params | email: email}

        assert {:ok, _changes} = Identities.insert_user(params)
      end)

      ~w[
        invalidemail.com
        invalid@email
      ]
      |> Enum.each(fn email ->
        params = %{@params | email: email}

        assert {:error, :user, _, _} = Identities.insert_user(params)
      end)
    end

    test "requires a password" do
      params = %{@params | password: ""}

      assert {:error, :password_identity, _, _} = Identities.insert_user(params)
    end
  end
end

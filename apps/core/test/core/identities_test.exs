defmodule Core.IdentitiesTest do
  use Core.DataCase, async: true

  alias Core.Identities

  @params Core.Fixtures.owner()

  def insert_owner(_) do
    {:ok, owner} = Identities.insert_owner(@params)
    %{owner: owner}
  end

  describe "find_owner/1" do
    setup [:insert_owner]

    test "returns a owner by email", %{owner: owner} do
      assert {:ok, _owner} = Identities.find_owner(%{email: owner.email})
      assert {:ok, _owner} = Identities.find_owner(%{id: owner.id})
    end
  end

  describe "insert_owner/1" do
    test "inserts a owner and the identity" do
      {:ok, owner} = Identities.insert_owner(@params)

      assert owner.name == @params.name
      assert owner.email == @params.email
    end

    test "requires a name" do
      params = %{@params | name: ""}

      assert {:error, _changeset} = Identities.insert_owner(params)
    end

    test "reqiures a email" do
      params = %{@params | email: ""}

      assert {:error, _changeset} = Identities.insert_owner(params)
    end

    test "validates email format" do
      ~w[
        valid@email.com
        thisis+valid@email.com
      ]
      |> Enum.each(fn email ->
        params = %{@params | email: email}

        assert {:ok, _owner} = Identities.insert_owner(params)
      end)

      ~w[
        invalidemail.com
        invalid@email
      ]
      |> Enum.each(fn email ->
        params = %{@params | email: email}

        assert {:error, _changeset} = Identities.insert_owner(params)
      end)
    end

    test "ensure email is unique" do
      assert {:ok, _owner} = Identities.insert_owner(@params)
      assert {:error, changeset} = Identities.insert_owner(@params)
      assert %{errors: [email: _]} = changeset
    end

    test "requires a password" do
      params = %{@params | password: ""}

      assert {:error, _changeset} = Identities.insert_owner(params)
    end
  end

  describe "correct_password?/2" do
    setup [:insert_owner]

    test "returns true when owner/password is correct", %{owner: owner} do
      assert Identities.correct_password?(owner, @params.password)
    end

    test "returns false when owner/password is not correct", %{owner: owner} do
      refute Identities.correct_password?(owner, @params.password <> "!!")
    end
  end

  describe "owner_from_token/1 and token_from_owner/1" do
    setup [:insert_owner]

    test "can inverse transform owner and token", %{owner: owner} do
      {:ok, token} = Identities.token_from_owner(owner)
      {:ok, returned_owner} = Identities.owner_from_token(token)

      assert returned_owner.name == owner.name
    end
  end
end

defmodule Core.IdentitiesTest do
  use Core.DataCase, async: true

  alias Core.Identities

  @params %{
    name: "John Doe",
    email: "john@doe.com",
    password: "s3cr3tp@ssw0rd"
  }

  def insert_user(_) do
    Identities.insert_user(@params)
  end

  describe "find_user/1" do
    setup [:insert_user]

    test "returns a user by email", %{user: user} do
      assert Identities.find_user(%{email: user.email})
      assert Identities.find_user(%{id: user.id})
    end
  end

  describe "insert_user/1" do
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

    test "ensure email is unique" do
      assert {:ok, _} = Identities.insert_user(@params)
      assert {:error, :user, changeset, _} = Identities.insert_user(@params)
      assert %{errors: [email: _]} = changeset
    end

    test "requires a password" do
      params = %{@params | password: ""}

      assert {:error, :password_identity, _, _} = Identities.insert_user(params)
    end
  end

  describe "correct_password?/2" do
    setup [:insert_user]

    test "returns true when user/password is correct", %{user: user} do
      assert Identities.correct_password?(user, @params.password)
    end

    test "returns false when user/password is not correct", %{user: user} do
      refute Identities.correct_password?(user, @params.password <> "!!")
    end
  end

  describe "user_from_token/1 and token_from_user/1" do
    setup [:insert_user]

    test "can inverse transform user and token", %{user: user} do
      {:ok, token} = Identities.token_from_user(user)
      {:ok, returned_user} = Identities.user_from_token(token)

      assert returned_user.name == user.name
    end
  end
end

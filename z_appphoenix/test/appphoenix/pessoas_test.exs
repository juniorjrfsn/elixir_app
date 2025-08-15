defmodule Appphoenix.PessoasTest do
  use Appphoenix.DataCase

  alias Appphoenix.Pessoas

  describe "persons" do
    alias Appphoenix.Pessoas.Pessoa

    import Appphoenix.PessoasFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_persons/0 returns all persons" do
      pessoa = pessoa_fixture()
      assert Pessoas.list_persons() == [pessoa]
    end

    test "get_pessoa!/1 returns the pessoa with given id" do
      pessoa = pessoa_fixture()
      assert Pessoas.get_pessoa!(pessoa.id) == pessoa
    end

    test "create_pessoa/1 with valid data creates a pessoa" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Pessoa{} = pessoa} = Pessoas.create_pessoa(valid_attrs)
      assert pessoa.name == "some name"
      assert pessoa.description == "some description"
    end

    test "create_pessoa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pessoas.create_pessoa(@invalid_attrs)
    end

    test "update_pessoa/2 with valid data updates the pessoa" do
      pessoa = pessoa_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Pessoa{} = pessoa} = Pessoas.update_pessoa(pessoa, update_attrs)
      assert pessoa.name == "some updated name"
      assert pessoa.description == "some updated description"
    end

    test "update_pessoa/2 with invalid data returns error changeset" do
      pessoa = pessoa_fixture()
      assert {:error, %Ecto.Changeset{}} = Pessoas.update_pessoa(pessoa, @invalid_attrs)
      assert pessoa == Pessoas.get_pessoa!(pessoa.id)
    end

    test "delete_pessoa/1 deletes the pessoa" do
      pessoa = pessoa_fixture()
      assert {:ok, %Pessoa{}} = Pessoas.delete_pessoa(pessoa)
      assert_raise Ecto.NoResultsError, fn -> Pessoas.get_pessoa!(pessoa.id) end
    end

    test "change_pessoa/1 returns a pessoa changeset" do
      pessoa = pessoa_fixture()
      assert %Ecto.Changeset{} = Pessoas.change_pessoa(pessoa)
    end
  end

  describe "persons" do
    alias Appphoenix.Pessoas.Pessoa

    import Appphoenix.PessoasFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_persons/0 returns all persons" do
      pessoa = pessoa_fixture()
      assert Pessoas.list_persons() == [pessoa]
    end

    test "get_pessoa!/1 returns the pessoa with given id" do
      pessoa = pessoa_fixture()
      assert Pessoas.get_pessoa!(pessoa.id) == pessoa
    end

    test "create_pessoa/1 with valid data creates a pessoa" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Pessoa{} = pessoa} = Pessoas.create_pessoa(valid_attrs)
      assert pessoa.name == "some name"
      assert pessoa.description == "some description"
    end

    test "create_pessoa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pessoas.create_pessoa(@invalid_attrs)
    end

    test "update_pessoa/2 with valid data updates the pessoa" do
      pessoa = pessoa_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Pessoa{} = pessoa} = Pessoas.update_pessoa(pessoa, update_attrs)
      assert pessoa.name == "some updated name"
      assert pessoa.description == "some updated description"
    end

    test "update_pessoa/2 with invalid data returns error changeset" do
      pessoa = pessoa_fixture()
      assert {:error, %Ecto.Changeset{}} = Pessoas.update_pessoa(pessoa, @invalid_attrs)
      assert pessoa == Pessoas.get_pessoa!(pessoa.id)
    end

    test "delete_pessoa/1 deletes the pessoa" do
      pessoa = pessoa_fixture()
      assert {:ok, %Pessoa{}} = Pessoas.delete_pessoa(pessoa)
      assert_raise Ecto.NoResultsError, fn -> Pessoas.get_pessoa!(pessoa.id) end
    end

    test "change_pessoa/1 returns a pessoa changeset" do
      pessoa = pessoa_fixture()
      assert %Ecto.Changeset{} = Pessoas.change_pessoa(pessoa)
    end
  end
end

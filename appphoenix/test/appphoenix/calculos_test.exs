defmodule Appphoenix.CalculosTest do
  use Appphoenix.DataCase

  alias Appphoenix.Calculos

  describe "calculos" do
    alias Appphoenix.Calculos.Calculo

    import Appphoenix.CalculosFixtures

    @invalid_attrs %{}

    test "list_calculos/0 returns all calculos" do
      calculo = calculo_fixture()
      assert Calculos.list_calculos() == [calculo]
    end

    test "get_calculo!/1 returns the calculo with given id" do
      calculo = calculo_fixture()
      assert Calculos.get_calculo!(calculo.id) == calculo
    end

    test "create_calculo/1 with valid data creates a calculo" do
      valid_attrs = %{}

      assert {:ok, %Calculo{} = calculo} = Calculos.create_calculo(valid_attrs)
    end

    test "create_calculo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calculos.create_calculo(@invalid_attrs)
    end

    test "update_calculo/2 with valid data updates the calculo" do
      calculo = calculo_fixture()
      update_attrs = %{}

      assert {:ok, %Calculo{} = calculo} = Calculos.update_calculo(calculo, update_attrs)
    end

    test "update_calculo/2 with invalid data returns error changeset" do
      calculo = calculo_fixture()
      assert {:error, %Ecto.Changeset{}} = Calculos.update_calculo(calculo, @invalid_attrs)
      assert calculo == Calculos.get_calculo!(calculo.id)
    end

    test "delete_calculo/1 deletes the calculo" do
      calculo = calculo_fixture()
      assert {:ok, %Calculo{}} = Calculos.delete_calculo(calculo)
      assert_raise Ecto.NoResultsError, fn -> Calculos.get_calculo!(calculo.id) end
    end

    test "change_calculo/1 returns a calculo changeset" do
      calculo = calculo_fixture()
      assert %Ecto.Changeset{} = Calculos.change_calculo(calculo)
    end
  end

  describe "calculos" do
    alias Appphoenix.Calculos.Calculo

    import Appphoenix.CalculosFixtures

    @invalid_attrs %{campo1: nil, campo2: nil}

    test "list_calculos/0 returns all calculos" do
      calculo = calculo_fixture()
      assert Calculos.list_calculos() == [calculo]
    end

    test "get_calculo!/1 returns the calculo with given id" do
      calculo = calculo_fixture()
      assert Calculos.get_calculo!(calculo.id) == calculo
    end

    test "create_calculo/1 with valid data creates a calculo" do
      valid_attrs = %{campo1: "120.5", campo2: "120.5"}

      assert {:ok, %Calculo{} = calculo} = Calculos.create_calculo(valid_attrs)
      assert calculo.campo1 == Decimal.new("120.5")
      assert calculo.campo2 == Decimal.new("120.5")
    end

    test "create_calculo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calculos.create_calculo(@invalid_attrs)
    end

    test "update_calculo/2 with valid data updates the calculo" do
      calculo = calculo_fixture()
      update_attrs = %{campo1: "456.7", campo2: "456.7"}

      assert {:ok, %Calculo{} = calculo} = Calculos.update_calculo(calculo, update_attrs)
      assert calculo.campo1 == Decimal.new("456.7")
      assert calculo.campo2 == Decimal.new("456.7")
    end

    test "update_calculo/2 with invalid data returns error changeset" do
      calculo = calculo_fixture()
      assert {:error, %Ecto.Changeset{}} = Calculos.update_calculo(calculo, @invalid_attrs)
      assert calculo == Calculos.get_calculo!(calculo.id)
    end

    test "delete_calculo/1 deletes the calculo" do
      calculo = calculo_fixture()
      assert {:ok, %Calculo{}} = Calculos.delete_calculo(calculo)
      assert_raise Ecto.NoResultsError, fn -> Calculos.get_calculo!(calculo.id) end
    end

    test "change_calculo/1 returns a calculo changeset" do
      calculo = calculo_fixture()
      assert %Ecto.Changeset{} = Calculos.change_calculo(calculo)
    end
  end

  describe "calculos" do
    alias Appphoenix.Calculos.Calculo

    import Appphoenix.CalculosFixtures

    @invalid_attrs %{campo1: nil, campo2: nil}

    test "list_calculos/0 returns all calculos" do
      calculo = calculo_fixture()
      assert Calculos.list_calculos() == [calculo]
    end

    test "get_calculo!/1 returns the calculo with given id" do
      calculo = calculo_fixture()
      assert Calculos.get_calculo!(calculo.id) == calculo
    end

    test "create_calculo/1 with valid data creates a calculo" do
      valid_attrs = %{campo1: 120.5, campo2: 120.5}

      assert {:ok, %Calculo{} = calculo} = Calculos.create_calculo(valid_attrs)
      assert calculo.campo1 == 120.5
      assert calculo.campo2 == 120.5
    end

    test "create_calculo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calculos.create_calculo(@invalid_attrs)
    end

    test "update_calculo/2 with valid data updates the calculo" do
      calculo = calculo_fixture()
      update_attrs = %{campo1: 456.7, campo2: 456.7}

      assert {:ok, %Calculo{} = calculo} = Calculos.update_calculo(calculo, update_attrs)
      assert calculo.campo1 == 456.7
      assert calculo.campo2 == 456.7
    end

    test "update_calculo/2 with invalid data returns error changeset" do
      calculo = calculo_fixture()
      assert {:error, %Ecto.Changeset{}} = Calculos.update_calculo(calculo, @invalid_attrs)
      assert calculo == Calculos.get_calculo!(calculo.id)
    end

    test "delete_calculo/1 deletes the calculo" do
      calculo = calculo_fixture()
      assert {:ok, %Calculo{}} = Calculos.delete_calculo(calculo)
      assert_raise Ecto.NoResultsError, fn -> Calculos.get_calculo!(calculo.id) end
    end

    test "change_calculo/1 returns a calculo changeset" do
      calculo = calculo_fixture()
      assert %Ecto.Changeset{} = Calculos.change_calculo(calculo)
    end
  end

  describe "calculos" do
    alias Appphoenix.Calculos.Calculo

    import Appphoenix.CalculosFixtures

    @invalid_attrs %{total: nil, campo1: nil, campo2: nil}

    test "list_calculos/0 returns all calculos" do
      calculo = calculo_fixture()
      assert Calculos.list_calculos() == [calculo]
    end

    test "get_calculo!/1 returns the calculo with given id" do
      calculo = calculo_fixture()
      assert Calculos.get_calculo!(calculo.id) == calculo
    end

    test "create_calculo/1 with valid data creates a calculo" do
      valid_attrs = %{total: 120.5, campo1: 120.5, campo2: 120.5}

      assert {:ok, %Calculo{} = calculo} = Calculos.create_calculo(valid_attrs)
      assert calculo.total == 120.5
      assert calculo.campo1 == 120.5
      assert calculo.campo2 == 120.5
    end

    test "create_calculo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calculos.create_calculo(@invalid_attrs)
    end

    test "update_calculo/2 with valid data updates the calculo" do
      calculo = calculo_fixture()
      update_attrs = %{total: 456.7, campo1: 456.7, campo2: 456.7}

      assert {:ok, %Calculo{} = calculo} = Calculos.update_calculo(calculo, update_attrs)
      assert calculo.total == 456.7
      assert calculo.campo1 == 456.7
      assert calculo.campo2 == 456.7
    end

    test "update_calculo/2 with invalid data returns error changeset" do
      calculo = calculo_fixture()
      assert {:error, %Ecto.Changeset{}} = Calculos.update_calculo(calculo, @invalid_attrs)
      assert calculo == Calculos.get_calculo!(calculo.id)
    end

    test "delete_calculo/1 deletes the calculo" do
      calculo = calculo_fixture()
      assert {:ok, %Calculo{}} = Calculos.delete_calculo(calculo)
      assert_raise Ecto.NoResultsError, fn -> Calculos.get_calculo!(calculo.id) end
    end

    test "change_calculo/1 returns a calculo changeset" do
      calculo = calculo_fixture()
      assert %Ecto.Changeset{} = Calculos.change_calculo(calculo)
    end
  end
end

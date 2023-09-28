defmodule Appphoenix.FisicaTest do
  use Appphoenix.DataCase

  alias Appphoenix.Fisica

  describe "fisica" do
    alias Appphoenix.Fisica.Formula

    import Appphoenix.FisicaFixtures

    @invalid_attrs %{massa: nil, espaco: nil}

    test "list_fisica/0 returns all fisica" do
      formula = formula_fixture()
      assert Fisica.list_fisica() == [formula]
    end

    test "get_formula!/1 returns the formula with given id" do
      formula = formula_fixture()
      assert Fisica.get_formula!(formula.id) == formula
    end

    test "create_formula/1 with valid data creates a formula" do
      valid_attrs = %{massa: 120.5, espaco: "some espaco"}

      assert {:ok, %Formula{} = formula} = Fisica.create_formula(valid_attrs)
      assert formula.massa == 120.5
      assert formula.espaco == "some espaco"
    end

    test "create_formula/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fisica.create_formula(@invalid_attrs)
    end

    test "update_formula/2 with valid data updates the formula" do
      formula = formula_fixture()
      update_attrs = %{massa: 456.7, espaco: "some updated espaco"}

      assert {:ok, %Formula{} = formula} = Fisica.update_formula(formula, update_attrs)
      assert formula.massa == 456.7
      assert formula.espaco == "some updated espaco"
    end

    test "update_formula/2 with invalid data returns error changeset" do
      formula = formula_fixture()
      assert {:error, %Ecto.Changeset{}} = Fisica.update_formula(formula, @invalid_attrs)
      assert formula == Fisica.get_formula!(formula.id)
    end

    test "delete_formula/1 deletes the formula" do
      formula = formula_fixture()
      assert {:ok, %Formula{}} = Fisica.delete_formula(formula)
      assert_raise Ecto.NoResultsError, fn -> Fisica.get_formula!(formula.id) end
    end

    test "change_formula/1 returns a formula changeset" do
      formula = formula_fixture()
      assert %Ecto.Changeset{} = Fisica.change_formula(formula)
    end
  end
end

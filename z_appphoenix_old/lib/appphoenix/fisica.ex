defmodule Appphoenix.Fisica do
  @moduledoc """
  The Fisica context.
  """

  import Ecto.Query, warn: false
  alias Appphoenix.Repo

  alias Appphoenix.Fisica.Formula

  @doc """
  Returns the list of fisica.

  ## Examples

      iex> list_fisica()
      [%Formula{}, ...]

  """
  def list_fisica do
    Repo.all(Formula)
  end

  @doc """
  Gets a single formula.

  Raises `Ecto.NoResultsError` if the Formula does not exist.

  ## Examples

      iex> get_formula!(123)
      %Formula{}

      iex> get_formula!(456)
      ** (Ecto.NoResultsError)

  """
  def get_formula!(id), do: Repo.get!(Formula, id)

  @doc """
  Creates a formula.

  ## Examples

      iex> create_formula(%{field: value})
      {:ok, %Formula{}}

      iex> create_formula(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_formula(attrs \\ %{}) do
    %Formula{}
    |> Formula.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a formula.

  ## Examples

      iex> update_formula(formula, %{field: new_value})
      {:ok, %Formula{}}

      iex> update_formula(formula, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_formula(%Formula{} = formula, attrs) do
    formula
    |> Formula.changeset(attrs)
    |> Repo.update()
  end

  def registrar_formula(%Formula{} = formula, attrs) do
    formula
    |> Formula.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a formula.

  ## Examples

      iex> delete_formula(formula)
      {:ok, %Formula{}}

      iex> delete_formula(formula)
      {:error, %Ecto.Changeset{}}

  """
  def delete_formula(%Formula{} = formula) do
    Repo.delete(formula)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking formula changes.

  ## Examples

      iex> change_formula(formula)
      %Ecto.Changeset{data: %Formula{}}

  """
  def change_formula(%Formula{} = formula, attrs \\ %{}) do
    Formula.changeset(formula, attrs)
  end

  def change_fisica_peso(%Formula{} = formula, attrs \\ %{}) do
    Formula.changeset(formula, attrs)
  end

  def change_fisica_forcag(%Formula{} = formula, attrs \\ %{}) do
    Formula.changeset(formula, attrs)
  end
end

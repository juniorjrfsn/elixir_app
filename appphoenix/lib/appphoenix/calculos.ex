defmodule Appphoenix.Calculos do
  @moduledoc """
  The Calculos context.
  """

  import Ecto.Query, warn: false
  alias Appphoenix.Repo

  alias Appphoenix.Calculos.Calculo

  @doc """
  Returns the list of calculos.

  ## Examples

      iex> list_calculos()
      [%Calculo{}, ...]

  """
  def list_calculos do
    Repo.all(Calculo)
  end

  @doc """
  Gets a single calculo.

  Raises `Ecto.NoResultsError` if the Calculo does not exist.

  ## Examples

      iex> get_calculo!(123)
      %Calculo{}

      iex> get_calculo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_calculo!(id), do: Repo.get!(Calculo, id)

  @doc """
  Creates a calculo.

  ## Examples

      iex> create_calculo(%{field: value})
      {:ok, %Calculo{}}

      iex> create_calculo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_calculo(attrs \\ %{}) do
    %Calculo{}
    |> Calculo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a calculo.

  ## Examples

      iex> update_calculo(calculo, %{field: new_value})
      {:ok, %Calculo{}}

      iex> update_calculo(calculo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_calculo(%Calculo{} = calculo, attrs) do
    calculo
    |> Calculo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a calculo.

  ## Examples

      iex> delete_calculo(calculo)
      {:ok, %Calculo{}}

      iex> delete_calculo(calculo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_calculo(%Calculo{} = calculo) do
    Repo.delete(calculo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking calculo changes.

  ## Examples

      iex> change_calculo(calculo)
      %Ecto.Changeset{data: %Calculo{}}

  """
  def change_calculo(%Calculo{} = calculo, attrs \\ %{}) do
    Calculo.changeset(calculo, attrs)
  end
end

defmodule Appphoenix.Pessoas do
  @moduledoc """
  The Pessoas context.
  """

  import Ecto.Query, warn: false
  alias Appphoenix.Repo

  alias Appphoenix.Pessoas.Pessoa

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Pessoa{}, ...]

  """
  def list_persons do
    Repo.all(Pessoa)
  end

  @doc """
  Gets a single pessoa.

  Raises `Ecto.NoResultsError` if the Pessoa does not exist.

  ## Examples

      iex> get_pessoa!(123)
      %Pessoa{}

      iex> get_pessoa!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pessoa!(id), do: Repo.get!(Pessoa, id)

  @doc """
  Creates a pessoa.

  ## Examples

      iex> create_pessoa(%{field: value})
      {:ok, %Pessoa{}}

      iex> create_pessoa(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pessoa(attrs \\ %{}) do
    %Pessoa{}
    |> Pessoa.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pessoa.

  ## Examples

      iex> update_pessoa(pessoa, %{field: new_value})
      {:ok, %Pessoa{}}

      iex> update_pessoa(pessoa, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pessoa(%Pessoa{} = pessoa, attrs) do
    pessoa
    |> Pessoa.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pessoa.

  ## Examples

      iex> delete_pessoa(pessoa)
      {:ok, %Pessoa{}}

      iex> delete_pessoa(pessoa)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pessoa(%Pessoa{} = pessoa) do
    Repo.delete(pessoa)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pessoa changes.

  ## Examples

      iex> change_pessoa(pessoa)
      %Ecto.Changeset{data: %Pessoa{}}

  """
  def change_pessoa(%Pessoa{} = pessoa, attrs \\ %{}) do
    Pessoa.changeset(pessoa, attrs)
  end
end

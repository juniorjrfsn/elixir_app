defmodule Appphoenix.Postsservice do
  @moduledoc """
  The Postsservice context.
  """

  import Ecto.Query, warn: false
  alias Appphoenix.Repo

  alias Appphoenix.Postsservice.Postservice

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Postservice{}, ...]

  """
  def list_posts do
    Repo.all(Postservice)
  end

  @doc """
  Gets a single postservice.

  Raises `Ecto.NoResultsError` if the Postservice does not exist.

  ## Examples

      iex> get_postservice!(123)
      %Postservice{}

      iex> get_postservice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_postservice!(id), do: Repo.get!(Postservice, id)

  @doc """
  Creates a postservice.

  ## Examples

      iex> create_postservice(%{field: value})
      {:ok, %Postservice{}}

      iex> create_postservice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_postservice(attrs \\ %{}) do
    %Postservice{}
    |> Postservice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a postservice.

  ## Examples

      iex> update_postservice(postservice, %{field: new_value})
      {:ok, %Postservice{}}

      iex> update_postservice(postservice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_postservice(%Postservice{} = postservice, attrs) do
    postservice
    |> Postservice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a postservice.

  ## Examples

      iex> delete_postservice(postservice)
      {:ok, %Postservice{}}

      iex> delete_postservice(postservice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_postservice(%Postservice{} = postservice) do
    Repo.delete(postservice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking postservice changes.

  ## Examples

      iex> change_postservice(postservice)
      %Ecto.Changeset{data: %Postservice{}}

  """
  def change_postservice(%Postservice{} = postservice, attrs \\ %{}) do
    Postservice.changeset(postservice, attrs)
  end
end

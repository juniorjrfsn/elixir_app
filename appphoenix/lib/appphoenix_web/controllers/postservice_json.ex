defmodule AppphoenixWeb.PostserviceJSON do
  alias Appphoenix.Postsservice.Postservice

  @doc """
  Renders a list of posts.
  """
  def index(%{posts: posts}) do
    %{data: for(postservice <- posts, do: data(postservice))}
  end

  @doc """
  Renders a single postservice.
  """
  def show(%{postservice: postservice}) do
    %{data: data(postservice)}
  end

  defp data(%Postservice{} = postservice) do
    %{
      id: postservice.id,
      title: postservice.title,
      body: postservice.body
    }
  end
end

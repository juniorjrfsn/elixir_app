defmodule AppphoenixWeb.PostserviceController do
  use AppphoenixWeb, :controller

  alias Appphoenix.Postsservice
  alias Appphoenix.Postsservice.Postservice

  action_fallback AppphoenixWeb.FallbackController

  def index(conn, _params) do
    posts = Postsservice.list_posts()
    render(conn, :index, posts: posts)
  end

  def create(conn, %{"postservice" => postservice_params}) do
    with {:ok, %Postservice{} = postservice} <- Postsservice.create_postservice(postservice_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/posts/#{postservice}")
      |> render(:show, postservice: postservice)
    end
  end

  def show(conn, %{"id" => id}) do
    postservice = Postsservice.get_postservice!(id)
    render(conn, :show, postservice: postservice)
  end

  def update(conn, %{"id" => id, "postservice" => postservice_params}) do
    postservice = Postsservice.get_postservice!(id)

    with {:ok, %Postservice{} = postservice} <- Postsservice.update_postservice(postservice, postservice_params) do
      render(conn, :show, postservice: postservice)
    end
  end

  def delete(conn, %{"id" => id}) do
    postservice = Postsservice.get_postservice!(id)

    with {:ok, %Postservice{}} <- Postsservice.delete_postservice(postservice) do
      send_resp(conn, :no_content, "")
    end
  end
end

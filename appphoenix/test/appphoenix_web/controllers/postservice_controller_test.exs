defmodule AppphoenixWeb.PostserviceControllerTest do
  use AppphoenixWeb.ConnCase

  import Appphoenix.PostsserviceFixtures

  alias Appphoenix.Postsservice.Postservice

  @create_attrs %{
    title: "some title",
    body: "some body"
  }
  @update_attrs %{
    title: "some updated title",
    body: "some updated body"
  }
  @invalid_attrs %{title: nil, body: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/api/posts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create postservice" do
    test "renders postservice when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/posts", postservice: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/posts/#{id}")

      assert %{
               "id" => ^id,
               "body" => "some body",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/posts", postservice: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update postservice" do
    setup [:create_postservice]

    test "renders postservice when data is valid", %{conn: conn, postservice: %Postservice{id: id} = postservice} do
      conn = put(conn, ~p"/api/posts/#{postservice}", postservice: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/posts/#{id}")

      assert %{
               "id" => ^id,
               "body" => "some updated body",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, postservice: postservice} do
      conn = put(conn, ~p"/api/posts/#{postservice}", postservice: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete postservice" do
    setup [:create_postservice]

    test "deletes chosen postservice", %{conn: conn, postservice: postservice} do
      conn = delete(conn, ~p"/api/posts/#{postservice}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/posts/#{postservice}")
      end
    end
  end

  defp create_postservice(_) do
    postservice = postservice_fixture()
    %{postservice: postservice}
  end
end

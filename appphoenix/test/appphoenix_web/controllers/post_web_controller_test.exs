defmodule AppphoenixWeb.PostWebControllerTest do
  use AppphoenixWeb.ConnCase

  import Appphoenix.PostWebsFixtures

  @create_attrs %{title: "some title", body: "some body"}
  @update_attrs %{title: "some updated title", body: "some updated body"}
  @invalid_attrs %{title: nil, body: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post_web" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post web"
    end
  end

  describe "create post_web" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post_web: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "Post web #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/posts", post_web: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post web"
    end
  end

  describe "edit post_web" do
    setup [:create_post_web]

    test "renders form for editing chosen post_web", %{conn: conn, post_web: post_web} do
      conn = get(conn, ~p"/posts/#{post_web}/edit")
      assert html_response(conn, 200) =~ "Edit Post web"
    end
  end

  describe "update post_web" do
    setup [:create_post_web]

    test "redirects when data is valid", %{conn: conn, post_web: post_web} do
      conn = put(conn, ~p"/posts/#{post_web}", post_web: @update_attrs)
      assert redirected_to(conn) == ~p"/posts/#{post_web}"

      conn = get(conn, ~p"/posts/#{post_web}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, post_web: post_web} do
      conn = put(conn, ~p"/posts/#{post_web}", post_web: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post web"
    end
  end

  describe "delete post_web" do
    setup [:create_post_web]

    test "deletes chosen post_web", %{conn: conn, post_web: post_web} do
      conn = delete(conn, ~p"/posts/#{post_web}")
      assert redirected_to(conn) == ~p"/posts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/posts/#{post_web}")
      end
    end
  end

  defp create_post_web(_) do
    post_web = post_web_fixture()
    %{post_web: post_web}
  end
end

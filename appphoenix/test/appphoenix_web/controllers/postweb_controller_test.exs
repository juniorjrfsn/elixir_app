defmodule AppphoenixWeb.PostwebControllerTest do
  use AppphoenixWeb.ConnCase

  import Appphoenix.PostwebsFixtures

  @create_attrs %{title: "some title", body: "some body"}
  @update_attrs %{title: "some updated title", body: "some updated body"}
  @invalid_attrs %{title: nil, body: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new postweb" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/posts/new")
      assert html_response(conn, 200) =~ "New Postweb"
    end
  end

  describe "create postweb" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/posts", postweb: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "Postweb #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/posts", postweb: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Postweb"
    end
  end

  describe "edit postweb" do
    setup [:create_postweb]

    test "renders form for editing chosen postweb", %{conn: conn, postweb: postweb} do
      conn = get(conn, ~p"/posts/#{postweb}/edit")
      assert html_response(conn, 200) =~ "Edit Postweb"
    end
  end

  describe "update postweb" do
    setup [:create_postweb]

    test "redirects when data is valid", %{conn: conn, postweb: postweb} do
      conn = put(conn, ~p"/posts/#{postweb}", postweb: @update_attrs)
      assert redirected_to(conn) == ~p"/posts/#{postweb}"

      conn = get(conn, ~p"/posts/#{postweb}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, postweb: postweb} do
      conn = put(conn, ~p"/posts/#{postweb}", postweb: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Postweb"
    end
  end

  describe "delete postweb" do
    setup [:create_postweb]

    test "deletes chosen postweb", %{conn: conn, postweb: postweb} do
      conn = delete(conn, ~p"/posts/#{postweb}")
      assert redirected_to(conn) == ~p"/posts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/posts/#{postweb}")
      end
    end
  end

  defp create_postweb(_) do
    postweb = postweb_fixture()
    %{postweb: postweb}
  end
end

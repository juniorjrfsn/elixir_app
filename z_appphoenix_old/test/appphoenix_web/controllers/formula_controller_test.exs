defmodule AppphoenixWeb.FormulaControllerTest do
  use AppphoenixWeb.ConnCase

  import Appphoenix.FisicaFixtures

  @create_attrs %{massa: 120.5, espaco: "some espaco"}
  @update_attrs %{massa: 456.7, espaco: "some updated espaco"}
  @invalid_attrs %{massa: nil, espaco: nil}

  describe "index" do
    test "lists all fisica", %{conn: conn} do
      conn = get(conn, ~p"/fisica")
      assert html_response(conn, 200) =~ "Listing Fisica"
    end
  end

  describe "new formula" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/fisica/new")
      assert html_response(conn, 200) =~ "New Formula"
    end
  end

  describe "create formula" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/fisica", formula: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/fisica/#{id}"

      conn = get(conn, ~p"/fisica/#{id}")
      assert html_response(conn, 200) =~ "Formula #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/fisica", formula: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Formula"
    end
  end

  describe "edit formula" do
    setup [:create_formula]

    test "renders form for editing chosen formula", %{conn: conn, formula: formula} do
      conn = get(conn, ~p"/fisica/#{formula}/edit")
      assert html_response(conn, 200) =~ "Edit Formula"
    end
  end

  describe "update formula" do
    setup [:create_formula]

    test "redirects when data is valid", %{conn: conn, formula: formula} do
      conn = put(conn, ~p"/fisica/#{formula}", formula: @update_attrs)
      assert redirected_to(conn) == ~p"/fisica/#{formula}"

      conn = get(conn, ~p"/fisica/#{formula}")
      assert html_response(conn, 200) =~ "some updated espaco"
    end

    test "renders errors when data is invalid", %{conn: conn, formula: formula} do
      conn = put(conn, ~p"/fisica/#{formula}", formula: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Formula"
    end
  end

  describe "delete formula" do
    setup [:create_formula]

    test "deletes chosen formula", %{conn: conn, formula: formula} do
      conn = delete(conn, ~p"/fisica/#{formula}")
      assert redirected_to(conn) == ~p"/fisica"

      assert_error_sent 404, fn ->
        get(conn, ~p"/fisica/#{formula}")
      end
    end
  end

  defp create_formula(_) do
    formula = formula_fixture()
    %{formula: formula}
  end
end

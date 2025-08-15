defmodule AppphoenixWeb.CalculoControllerTest do
  use AppphoenixWeb.ConnCase

  import Appphoenix.CalculosFixtures

  @create_attrs %{total: 120.5, campo1: 120.5, campo2: 120.5}
  @update_attrs %{total: 456.7, campo1: 456.7, campo2: 456.7}
  @invalid_attrs %{total: nil, campo1: nil, campo2: nil}

  describe "index" do
    test "lists all calculos", %{conn: conn} do
      conn = get(conn, ~p"/calculos")
      assert html_response(conn, 200) =~ "Listing Calculos"
    end
  end

  describe "new calculo" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/calculos/new")
      assert html_response(conn, 200) =~ "New Calculo"
    end
  end

  describe "create calculo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/calculos", calculo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/calculos/#{id}"

      conn = get(conn, ~p"/calculos/#{id}")
      assert html_response(conn, 200) =~ "Calculo #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/calculos", calculo: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Calculo"
    end
  end

  describe "edit calculo" do
    setup [:create_calculo]

    test "renders form for editing chosen calculo", %{conn: conn, calculo: calculo} do
      conn = get(conn, ~p"/calculos/#{calculo}/edit")
      assert html_response(conn, 200) =~ "Edit Calculo"
    end
  end

  describe "update calculo" do
    setup [:create_calculo]

    test "redirects when data is valid", %{conn: conn, calculo: calculo} do
      conn = put(conn, ~p"/calculos/#{calculo}", calculo: @update_attrs)
      assert redirected_to(conn) == ~p"/calculos/#{calculo}"

      conn = get(conn, ~p"/calculos/#{calculo}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, calculo: calculo} do
      conn = put(conn, ~p"/calculos/#{calculo}", calculo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Calculo"
    end
  end

  describe "delete calculo" do
    setup [:create_calculo]

    test "deletes chosen calculo", %{conn: conn, calculo: calculo} do
      conn = delete(conn, ~p"/calculos/#{calculo}")
      assert redirected_to(conn) == ~p"/calculos"

      assert_error_sent 404, fn ->
        get(conn, ~p"/calculos/#{calculo}")
      end
    end
  end

  defp create_calculo(_) do
    calculo = calculo_fixture()
    %{calculo: calculo}
  end
end

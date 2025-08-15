defmodule AppphoenixWeb.PessoaControllerTest do
  use AppphoenixWeb.ConnCase

  import Appphoenix.PessoasFixtures

  alias Appphoenix.Pessoas.Pessoa

  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description"
  }
  @invalid_attrs %{name: nil, description: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all persons", %{conn: conn} do
      conn = get(conn, ~p"/api/persons")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create pessoa" do
    test "renders pessoa when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/persons", pessoa: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/persons/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/persons", pessoa: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pessoa" do
    setup [:create_pessoa]

    test "renders pessoa when data is valid", %{conn: conn, pessoa: %Pessoa{id: id} = pessoa} do
      conn = put(conn, ~p"/api/persons/#{pessoa}", pessoa: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/persons/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, pessoa: pessoa} do
      conn = put(conn, ~p"/api/persons/#{pessoa}", pessoa: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pessoa" do
    setup [:create_pessoa]

    test "deletes chosen pessoa", %{conn: conn, pessoa: pessoa} do
      conn = delete(conn, ~p"/api/persons/#{pessoa}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/persons/#{pessoa}")
      end
    end
  end

  defp create_pessoa(_) do
    pessoa = pessoa_fixture()
    %{pessoa: pessoa}
  end
end

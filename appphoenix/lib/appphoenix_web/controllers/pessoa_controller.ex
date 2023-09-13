defmodule AppphoenixWeb.PessoaController do
  use AppphoenixWeb, :controller

  alias Appphoenix.Pessoas
  alias Appphoenix.Pessoas.Pessoa

  action_fallback AppphoenixWeb.FallbackController

  def index(conn, _params) do
    persons = Pessoas.list_persons()
    render(conn, :index, persons: persons)
  end

  def create(conn, %{"pessoa" => pessoa_params}) do
    with {:ok, %Pessoa{} = pessoa} <- Pessoas.create_pessoa(pessoa_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/persons/#{pessoa}")
      |> render(:show, pessoa: pessoa)
    end
  end

  def show(conn, %{"id" => id}) do
    pessoa = Pessoas.get_pessoa!(id)
    render(conn, :show, pessoa: pessoa)
  end

  def update(conn, %{"id" => id, "pessoa" => pessoa_params}) do
    pessoa = Pessoas.get_pessoa!(id)

    with {:ok, %Pessoa{} = pessoa} <- Pessoas.update_pessoa(pessoa, pessoa_params) do
      render(conn, :show, pessoa: pessoa)
    end
  end

  def delete(conn, %{"id" => id}) do
    pessoa = Pessoas.get_pessoa!(id)

    with {:ok, %Pessoa{}} <- Pessoas.delete_pessoa(pessoa) do
      send_resp(conn, :no_content, "")
    end
  end
end

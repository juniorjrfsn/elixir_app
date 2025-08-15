defmodule AppphoenixWeb.CalculoController do
  use AppphoenixWeb, :controller

  alias Appphoenix.Calculos
  alias Appphoenix.Calculos.Calculo

  def index(conn, _params) do
    calculos = Calculos.list_calculos()
    render(conn, :index, calculos: calculos)
  end

  def new(conn, _params) do
    changeset = Calculos.change_calculo(%Calculo{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"calculo" => calculo_params}) do
    case Calculos.create_calculo(calculo_params) do
      {:ok, calculo} ->
        conn
        |> put_flash(:info, "Calculo created successfully.")
        |> redirect(to: ~p"/calculos/#{calculo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    calculo = Calculos.get_calculo!(id)
    render(conn, :show, calculo: calculo)
  end

  def edit(conn, %{"id" => id}) do
    calculo = Calculos.get_calculo!(id)
    changeset = Calculos.change_calculo(calculo)
    render(conn, :edit, calculo: calculo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "calculo" => calculo_params}) do
    calculo = Calculos.get_calculo!(id)

    case Calculos.update_calculo(calculo, calculo_params) do
      {:ok, calculo} ->
        conn
        |> put_flash(:info, "Calculo updated successfully.")
        |> redirect(to: ~p"/calculos/#{calculo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, calculo: calculo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    calculo = Calculos.get_calculo!(id)
    {:ok, _calculo} = Calculos.delete_calculo(calculo)

    conn
    |> put_flash(:info, "Calculo deleted successfully.")
    |> redirect(to: ~p"/calculos")
  end
end

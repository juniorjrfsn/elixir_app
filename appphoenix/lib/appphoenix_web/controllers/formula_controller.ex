defmodule AppphoenixWeb.FormulaController do
  use AppphoenixWeb, :controller

  alias Appphoenix.Fisica
  alias Appphoenix.Fisica.Formula

  def index(conn, _params) do
    fisica = Fisica.list_fisica()
    render(conn, :index, fisica: fisica)
  end

  def new(conn, _params) do
    changeset = Fisica.change_formula(%Formula{})
    render(conn, :new, changeset: changeset)
  end

  def peso(conn, _params) do
    #changeset = Fisica.change_formula(%Formula{})
    #render(conn, :peso, changeset: changeset)
    changeset = Fisica.change_fisica_peso(%Formula{})
    render(conn, :peso,changeset: changeset)
  end


  def calcpeso(conn, %{"calculo" => calculo_params}) do

    massa = elem(Float.parse(calculo_params["massa"]),0)
    espaco =  calculo_params["espaco"]
    total = massa

    calculo = %Appphoenix.Fisica.Formula{
      massa: massa,
      espaco: espaco,
      total: total
    }
    conn
      |> put_flash(:info, "Calculo created successfully. #{total} " )
      #  |> redirect(to: ~p"/calculos/new")

     changeset = Fisica.change_fisica_peso(calculo)
     render(conn, :new, calculo: calculo, changeset: changeset) 
end
  def create(conn, %{"formula" => formula_params}) do
    case Fisica.create_formula(formula_params) do
      {:ok, formula} ->
        conn
        |> put_flash(:info, "Formula created successfully.")
        |> redirect(to: ~p"/fisica/#{formula}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    formula = Fisica.get_formula!(id)
    render(conn, :show, formula: formula)
  end

  def edit(conn, %{"id" => id}) do
    formula = Fisica.get_formula!(id)
    changeset = Fisica.change_formula(formula)
    render(conn, :edit, formula: formula, changeset: changeset)
  end

  def update(conn, %{"id" => id, "formula" => formula_params}) do
    formula = Fisica.get_formula!(id)

    case Fisica.update_formula(formula, formula_params) do
      {:ok, formula} ->
        conn
        |> put_flash(:info, "Formula updated successfully.")
        |> redirect(to: ~p"/fisica/#{formula}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, formula: formula, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    formula = Fisica.get_formula!(id)
    {:ok, _formula} = Fisica.delete_formula(formula)

    conn
    |> put_flash(:info, "Formula deleted successfully.")
    |> redirect(to: ~p"/fisica")
  end
end

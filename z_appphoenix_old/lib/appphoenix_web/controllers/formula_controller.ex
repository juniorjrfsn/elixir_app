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

  def calcpeso(conn, %{"formula" => formula_params}) do
    massa = elem(Float.parse(formula_params["massa"]),0)
    espaco =  formula_params["espaco"]
    {aceleracao,corpoceleste,peso} = case espaco do
      "Sol"   -> {274.13              , "Sol"     ,(massa * 274.13)               }
      "Terra" -> {9.819649737724951   , "Terra"   ,(massa * 9.819649737724951)    }
      "Lua"   -> {1.625               , "Lua"     ,(massa * 1.625)                }
      "Marte" -> {3.72076             , "Marte"   ,(massa * 3.72076)              }
      _ ->       {0                   , "..."     , massa                         }
    end
    formula = %Appphoenix.Fisica.Formula{
      massa:  massa,
      espaco: espaco,
      peso:   peso,
      aceleracao: aceleracao
    }
    conn
    |> put_flash(:info, "Calculo created successfully. #{peso} #{corpoceleste} " )
    #  |> redirect(to: ~p"/formula/new")
    changeset = Fisica.change_fisica_peso(formula)
    render(conn, :peso, formula: formula, changeset: changeset)
  end

  def forcag(conn, _params) do
    #changeset = Fisica.change_formula(%Formula{})
    #render(conn, :peso, changeset: changeset)
    changeset = Fisica.change_fisica_forcag(%Formula{})
    render(conn, :forcag,changeset: changeset)
  end

  def calcforcag(conn, %{"formula" => formula_params}) do
    massa1    = elem(Float.parse(formula_params["massa1"]),0)
    massa2    = elem(Float.parse(formula_params["massa2"]),0)
    distancia = elem(Float.parse(formula_params["distancia"]),0)
    fg = (
        ( (6.67408 * :math.pow(10,-11)) * massa1 * massa2 )
        /
        :math.pow(distancia,2)
    )
    formula = %Appphoenix.Fisica.Formula{
      massa:      0.0,
      espaco:     "...",
      massa1:     massa1,
      massa2:     massa2,
      distancia:  distancia,
      newton:     fg
    }
    changeset = Fisica.change_fisica_forcag(formula)
    case Fisica.registrar_formula(formula,formula_params) do
      {:ok, formula} ->
        conn
        |> put_flash(:info, "ForcaG registrado successfully. #{fg} ")
        #|> redirect(to: ~p"/fisica/forcag")
        #|> redirect(to: ~p"/fisica")
        render(conn, :forcag, formula: formula, changeset: changeset)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :forcag, changeset: changeset)
    end
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

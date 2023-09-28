defmodule AppphoenixWeb.FormulaHTML do
  use AppphoenixWeb, :html

  embed_templates "formula_html/*"

  @doc """
  Renders a formula form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def formula_form(assigns)
end

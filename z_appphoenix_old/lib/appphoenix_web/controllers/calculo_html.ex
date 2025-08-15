defmodule AppphoenixWeb.CalculoHTML do
  use AppphoenixWeb, :html

  embed_templates "calculo_html/*"

  @doc """
  Renders a calculo form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def calculo_form(assigns)
end

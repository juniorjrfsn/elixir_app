defmodule AppphoenixWeb.PageController do
  use AppphoenixWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

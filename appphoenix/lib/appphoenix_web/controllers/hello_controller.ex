defmodule AppphoenixWeb.HelloController do
    use AppphoenixWeb, :controller

    def index(conn, _params) do
        render(conn, :index, layout: false)
    end
end
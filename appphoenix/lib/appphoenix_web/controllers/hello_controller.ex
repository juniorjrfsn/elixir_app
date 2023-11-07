defmodule AppphoenixWeb.HelloController do
    use AppphoenixWeb, :controller

    alias Appphoenix.Hellos
    alias Appphoenix.Hellos.Hello

    def index(conn, _params) do
        render(conn, :index, layout: false)
    end

    def render("404.html", _assigns) do
        "Page Not Found"
    end

    def show(conn, %{"messenger" => messenger}) do
        hello = %Appphoenix.Hellos.Hello{
            campo1: 0,
            campo2: 0,
            total: 0
        }
        changeset = Hellos.change_hello(hello)
        mensagem = "olá #{messenger}";
        render(conn, :show, messenger: mensagem, changeset: changeset )
    end
end

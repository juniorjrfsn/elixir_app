defmodule AppphoenixWeb.Router do
  use AppphoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AppphoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppphoenixWeb do
    pipe_through :browser

    get "/", PageController, :home

    # get "/fisica/peso", FormulaController, :peso
    # post "/fisica/calcpeso", FormulaController, :calcpeso

    # get "/fisica/forcag", FormulaController, :forcag
    # post "/fisica/calcforcag", FormulaController, :calcforcag

    # get "/fisica/delete/:id", FormulaController, :delete

    # resources "/hello", HelloController
    # get "/hellomsg/:messenger", HelloController, :show

    resources "/persons", PersonController
    resources "/tasks", TaskController
    resources "/post_web", TaskController
    resources "/posts", PostController
    resources "/calculos", CalculoController
    # resources "/fisica", FormulaController


  end

  scope "/api", AppphoenixWeb do
    pipe_through :api
    resources "/posts", PostController, except: [:new, :edit]
    #resources "/persons", PessoaController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppphoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:appphoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AppphoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

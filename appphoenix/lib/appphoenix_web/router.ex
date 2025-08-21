defmodule AppphoenixWeb.Router do
  use AppphoenixWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {AppphoenixWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", AppphoenixWeb do
    pipe_through(:browser)

    get("/", PageController, :home)

    # Upload de imagens
    get("/upload", ImageController, :new)
    post("/upload", ImageController, :create)

    get("/gallery", ImageController, :gallery)  # Ver todas as imagens
    get("/images/:filename", ImageController, :show)  # Ver imagem específica

    # Galeria de imagens
    get("/gallery", ImageController, :gallery)
    get("/gallery/:filename", ImageController, :show)
    get("/images/:filename", ImageController, :show)
  end

  # API endpoints para deep learning
  scope "/api", AppphoenixWeb do
    pipe_through(:api)

    # Listar todas as imagens para processamento
    get("/images", ImageController, :list)

    # Processar todas as imagens em lote
    post("/images/process", ImageController, :process_batch)

    # Processar uma imagem específica
    post("/images/:filename/process", ImageController, :process_single)

    # Obter resultados do processamento
    get("/images/:filename/results", ImageController, :get_results)

    # Status do processamento
    get("/processing/status", ProcessingController, :status)
  end

    # Servir arquivos de upload estaticamente
  scope "/" do
    pipe_through(:browser)

    # Servir imagens uploadadas
    get("/uploads/*path", ImageController, :serve_image)
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
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: AppphoenixWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end

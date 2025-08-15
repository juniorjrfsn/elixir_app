defmodule Appphoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AppphoenixWeb.Telemetry,
      Appphoenix.Repo,
      {DNSCluster, query: Application.get_env(:appphoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Appphoenix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Appphoenix.Finch},
      # Start a worker by calling: Appphoenix.Worker.start_link(arg)
      # {Appphoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      AppphoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Appphoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AppphoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule ColorClassifier.MixProject do
  use Mix.Project

  def project do
    [
      app: :color_classifier,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end



  defp deps do
    [
      {:nx, "~> 0.5"},
      {:axon, "~> 0.5"},
      {:exla, "~> 0.5"}
    ]
  end
end

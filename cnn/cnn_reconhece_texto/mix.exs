# file : lib/utils.ex
defmodule CnnReconheceTexto.MixProject do
  use Mix.Project

  def project do
    [
      app: :cnn_reconhece_texto,
      version: "0.1.0",
      elixir: "~> 1.18.2",
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
      {:nx, "~> 0.9"},
      {:jason, "~> 1.4"}
    ]
  end
end
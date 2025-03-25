# file: lib/cnn_reconhece_texto/cm/layer.ex
defmodule CmReconheceTexto.CM.Layer do
  @moduledoc """
  Implementação otimizada das camadas da CNN com:
  - Inicialização He
  - Batch Normalization
  - Suporte a diferentes funções de ativação
  """
  import Nx.Defn

  @enforce_keys [:type, :filters, :kernel_size, :activation]
  defstruct [
    :type, :filters, :kernel_size, :activation,
    :weights, :bias, :stride, :padding
  ]

  @doc """
  Cria uma nova camada convolucional com inicialização He.
  """
  def new_conv(filters, kernel_size, opts \\ []) do
    stride = Keyword.get(opts, :stride, 1)
    padding = Keyword.get(opts, :padding, :same)
    activation = Keyword.get(opts, :activation, :relu)

    weights = initialize_he_weights(filters, kernel_size)
    bias = Nx.broadcast(0.0, {filters})

    %__MODULE__{
      type: :conv,
      filters: filters,
      kernel_size: kernel_size,
      weights: weights,
      bias: bias,
      activation: activation,
      stride: stride,
      padding: padding
    }
  end

  defp initialize_he_weights(filters, kernel_size) do
    scale = :math.sqrt(2.0 / (kernel_size * kernel_size))
    Nx.random_normal({filters, kernel_size, kernel_size}) |> Nx.multiply(scale)
  end
end
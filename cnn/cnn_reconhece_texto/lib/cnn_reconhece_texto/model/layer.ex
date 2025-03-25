# file: lib/cnn_reconhece_texto/model/layer.ex
defmodule CnnReconheceTexto.Model.Layer do
  @moduledoc """
  Camadas da CNN: convolucional, pooling e densa.
  """

  alias CnnReconheceTexto.Utils.TensorOperations

  defstruct type: nil, weights: nil, bias: nil, activation: nil, kernel_size: nil

  @doc """
  Cria uma nova camada convolucional.
  """
  def new_conv(filters, kernel_size, opts \\ []) do
    activation = Keyword.get(opts, :activation, :relu)
    weights = TensorOperations.random_uniform({filters, kernel_size, kernel_size})
    bias = TensorOperations.zeros({filters})

    %__MODULE__{
      type: :conv,
      weights: weights,
      bias: bias,
      activation: activation
    }
  end

  @doc """
  Cria uma nova camada de pooling.
  """
  def new_pool(kernel_size) do
    %__MODULE__{
      type: :pool,
      kernel_size: kernel_size
    }
  end

  @doc """
  Cria uma nova camada densa.
  """
  def new_dense(units, opts \\ []) do
    activation = Keyword.get(opts, :activation, :relu)
    weights = TensorOperations.random_uniform({units})
    bias = TensorOperations.zeros({units})

    %__MODULE__{
      type: :dense,
      weights: weights,
      bias: bias,
      activation: activation
    }
  end

  @doc """
  Executa a passagem forward em uma camada.
  """
  def forward(layer, input) do
    case layer.type do
      :conv ->
        TensorOperations.conv2d(input, layer.weights)
        |> TensorOperations.add(layer.bias)
        |> apply_activation(layer.activation)

      :pool ->
        TensorOperations.max_pool(input, layer.kernel_size)

      :dense ->
        TensorOperations.dot(input, layer.weights)
        |> TensorOperations.add(layer.bias)
        |> apply_activation(layer.activation)
    end
  end

  defp apply_activation(tensor, :relu), do: TensorOperations.relu(tensor)
  defp apply_activation(tensor, :softmax), do: TensorOperations.softmax(tensor)
  defp apply_activation(tensor, _), do: tensor
end
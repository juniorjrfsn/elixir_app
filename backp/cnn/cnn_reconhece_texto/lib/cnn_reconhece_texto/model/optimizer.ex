# file: lib/cnn_reconhece_texto/model/optimizer.ex
defmodule CnnReconheceTexto.Model.Optimizer do
  @moduledoc """
  Otimizador Stochastic Gradient Descent (SGD).
  """

  alias CnnReconheceTexto.Utils.TensorOperations

  def update(weights, gradients, learning_rate) do
    TensorOperations.subtract(weights, TensorOperations.multiply(gradients, learning_rate))
  end
end
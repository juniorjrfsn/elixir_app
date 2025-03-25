# file: lib/cnn_reconhece_texto/model/loss.ex
defmodule CnnReconheceTexto.Model.Loss do
  @moduledoc """
  Funções de perda para treinamento.
  """

  alias CnnReconheceTexto.Utils.TensorOperations

  def cross_entropy(predictions, targets) do
    TensorOperations.sum(TensorOperations.multiply(targets, TensorOperations.log(predictions)))
    |> TensorOperations.negate()
  end
end
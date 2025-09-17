# file: lib/cnn_reconhece_texto/utils/tensor_operations.ex
defmodule CnnReconheceTexto.Utils.TensorOperations do
  @moduledoc """
  Operações matemáticas básicas para manipulação de tensores.
  """

  def from_list(data) do
    Nx.tensor(data)
  end

  def random_uniform(shape) do
    Nx.random_uniform(shape)
  end

  def zeros(shape) do
    Nx.zeros(shape)
  end

  def divide(tensor, value) do
    Nx.divide(tensor, value)
  end

  def mean(tensor, opts) do
    axes = Keyword.get(opts, :axes, [])
    Nx.mean(tensor, axes: axes)
  end

  def resize(tensor, {new_height, new_width}) do
    Nx.reshape(tensor, {new_height, new_width, Nx.shape(tensor) |> Enum.at(2)})
  end

  def conv2d(input, kernel) do
    Nx.conv(input, kernel)
  end

  def add(tensor1, tensor2) do
    Nx.add(tensor1, tensor2)
  end

  def max_pool(input, opts) do
    kernel_size = Keyword.get(opts, :kernel_size, {2, 2})
    Nx.max_pool(input, kernel_size: kernel_size)
  end

  def dot(tensor1, tensor2) do
    Nx.dot(tensor1, tensor2)
  end

  def relu(tensor) do
    Nx.max(tensor, 0)
  end

  def softmax(tensor) do
    exp_tensor = Nx.exp(tensor)
    Nx.divide(exp_tensor, Nx.sum(exp_tensor))
  end

  def sum(tensor) do
    Nx.sum(tensor)
  end

  def multiply(tensor1, tensor2) do
    Nx.multiply(tensor1, tensor2)
  end

  def log(tensor) do
    Nx.log(tensor)
  end

  def negate(tensor) do
    Nx.negate(tensor)
  end

  def subtract(tensor1, tensor2) do
    Nx.subtract(tensor1, tensor2)
  end
end
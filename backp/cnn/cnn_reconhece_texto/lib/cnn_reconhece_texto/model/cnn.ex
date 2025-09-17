# file: lib/cnn_reconhece_texto/model/cnn.ex
defmodule CnnReconheceTexto.Model.CNN do
  alias CnnReconheceTexto.Model.Layer

  defstruct layers: []

  def new(input_shape, output_size) do
    %__MODULE__{
      layers: build_cnn_layers(input_shape, output_size)
    }
  end

  def forward(cnn, input) do
    Enum.reduce(cnn.layers, input, fn layer, acc_input ->
      Layer.forward(layer, acc_input)
    end)
  end

  def train(cnn, input, target) do
    # Simulação de treinamento
    cnn
  end

  def predict(cnn, input) do
    forward(cnn, input)
  end

  defp build_cnn_layers({_channels, _height, _width}, output_size) do
    [
      Layer.new_conv(32, {3, 3}, activation: :relu),
      Layer.new_pool({2, 2}),
      Layer.new_dense(output_size, activation: :softmax)
    ]
  end
end
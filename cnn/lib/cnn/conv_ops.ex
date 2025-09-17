# lib/cnn/conv_ops.ex
defmodule Cnn.ConvOps do
  @moduledoc """
  Convolutional operations for the CNN
  """

  alias Cnn.{Matrix, Utils}

  @doc """
  Forward pass through convolutional layer
  """
  def conv_forward(input, conv_layer, layer_name) do
    IO.puts("#{layer_name}: Aplicando #{length(conv_layer.filters)} filtros 3x3")

    results = conv_layer.filters
    |> Enum.with_index(1)
    |> Enum.map(fn {filter, i} ->
      bias = Enum.at(conv_layer.bias, i - 1)
      output = convolve_2d(input, filter, bias)
      IO.puts("  Filtro #{i} -> Mapa #{length(output)}x#{length(Enum.at(output, 0))} (bias: #{:io_lib.format("~.4f", [bias])})")
      output
    end)

    IO.puts("")
    results
  end

  @doc """
  2D Convolution operation
  """
  def convolve_2d(input, filter, bias) do
    input_height = length(input)
    input_width = length(Enum.at(input, 0))
    filter_height = length(filter)
    filter_width = length(Enum.at(filter, 0))

    output_height = max(1, input_height - filter_height + 1)
    output_width = max(1, input_width - filter_width + 1)

    case {output_height, output_width} do
      {h, w} when h > 0 and w > 0 ->
        for i <- 0..(output_height - 1) do
          for j <- 0..(output_width - 1) do
            conv_value = convolve_at_position(input, filter, i, j)
            Utils.relu(conv_value + bias)
          end
        end

      _ ->
        # If dimensions result in invalid size, return 1x1 matrix
        [[Utils.relu(bias)]]
    end
  end

  @doc """
  Convolution at specific position
  """
  def convolve_at_position(input, filter, start_i, start_j) do
    filter_height = length(filter)
    filter_width = length(Enum.at(filter, 0))

    for i <- 0..(filter_height - 1), j <- 0..(filter_width - 1) do
      input_val = Matrix.get_element(input, start_i + i, start_j + j)
      filter_val = Matrix.get_element(filter, i, j)
      input_val * filter_val
    end
    |> Enum.sum()
  end

  @doc """
  Max pooling operation
  """
  def max_pool(input_maps, layer_name) do
    IO.puts("#{layer_name}: Max pooling 2x2")

    results = Enum.map(input_maps, &pool_2x2/1)
    IO.puts("  Reduzindo #{length(input_maps)} mapas para tamanho menor\n")
    results
  end

  @doc """
  2x2 Pooling operation
  """
  def pool_2x2(matrix) do
    height = length(matrix)
    width = length(Enum.at(matrix, 0))

    case {height, width} do
      {h, w} when h >= 2 and w >= 2 ->
        out_height = max(1, div(h, 2))
        out_width = max(1, div(w, 2))

        for i <- 0..(out_height - 1) do
          for j <- 0..(out_width - 1) do
            max_in_region(matrix, i, j)
          end
        end

      {1, 1} ->
        matrix  # Already 1x1

      _ ->
        # For small matrices, return max value as 1x1
        max_val = matrix |> List.flatten() |> Enum.max()
        [[max_val]]
    end
  end

  @doc """
  Finds maximum in a 2x2 region
  """
  def max_in_region(matrix, start_i, start_j) do
    height = length(matrix)
    width = length(Enum.at(matrix, 0))

    values = for di <- [0, 1], dj <- [0, 1] do
      row = start_i * 2 + di
      col = start_j * 2 + dj

      if row < height and col < width do
        Matrix.get_element(matrix, row, col)
      else
        nil
      end
    end
    |> Enum.filter(&(&1 != nil))

    case values do
      [] -> 0.0
      _ -> Enum.max(values)
    end
  end

  @doc """
  Applies ReLU activation to entire matrix
  """
  def apply_relu(matrix) do
    for row <- matrix do
      for val <- row do
        Utils.relu(val)
      end
    end
  end

  @doc """
  Pads matrix with zeros
  """
  def pad_matrix(matrix, padding) do
    height = length(matrix)
    width = length(Enum.at(matrix, 0))

    # Create padded matrix
    padded_height = height + 2 * padding
    padded_width = width + 2 * padding

    for i <- 0..(padded_height - 1) do
      for j <- 0..(padded_width - 1) do
        cond do
          i < padding or i >= height + padding or j < padding or j >= width + padding ->
            0.0
          true ->
            Matrix.get_element(matrix, i - padding, j - padding)
        end
      end
    end
  end

  @doc """
  Applies stride to convolution
  """
  def convolve_with_stride(input, filter, bias, stride) do
    input_height = length(input)
    input_width = length(Enum.at(input, 0))
    filter_height = length(filter)
    filter_width = length(Enum.at(filter, 0))

    output_height = max(1, div(input_height - filter_height, stride) + 1)
    output_width = max(1, div(input_width - filter_width, stride) + 1)

    for i <- 0..(output_height - 1) do
      for j <- 0..(output_width - 1) do
        conv_value = convolve_at_position(input, filter, i * stride, j * stride)
        Utils.relu(conv_value + bias)
      end
    end
  end
end

# lib/cnn/utils.ex
defmodule Cnn.Utils do
  @moduledoc """
  Utilities for matrix manipulation and neural network operations
  """

  @doc """
  Converts integer matrix to float matrix
  """
  def integer_to_float_matrix(matrix) do
    for row <- matrix do
      for x <- row do
        x * 1.0
      end
    end
  end

  @doc """
  Normalizes matrix to values between 0 and 1
  """
  def normalize_matrix(matrix) do
    flat_values = List.flatten(matrix)
    min_val = Enum.min(flat_values)
    max_val = Enum.max(flat_values)
    range = max_val - min_val

    case range do
      0 -> matrix  # If all values are equal
      _ ->
        for row <- matrix do
          for x <- row do
            (x - min_val) / range
          end
        end
    end
  end

  @doc """
  Prints matrix comparison
  """
  def print_matrix_comparison(original, modified) do
    IO.puts("Original -> Modificada:")

    original
    |> Enum.zip(modified)
    |> Enum.each(fn {row_orig, row_mod} ->
      comp_row = row_orig
      |> Enum.zip(row_mod)
      |> Enum.map(fn
        {same, same} -> to_string(same)
        {orig, mod} -> "#{orig}->#{mod}"
      end)
      |> Enum.join(" ")

      IO.puts("  #{comp_row}")
    end)

    IO.puts("")
  end

  @doc """
  Calculates matrix statistics
  """
  def matrix_stats(matrix) do
    flat_values = List.flatten(matrix)
    sum = Enum.sum(flat_values)
    count = length(flat_values)
    mean = sum / count
    min_val = Enum.min(flat_values)
    max_val = Enum.max(flat_values)

    IO.puts("Estatísticas da matriz:")
    IO.puts("  Tamanho: #{length(matrix)}x#{length(Enum.at(matrix, 0))} (#{count} elementos)")
    IO.puts("  Min: #{:io_lib.format("~.3f", [min_val])}, Max: #{:io_lib.format("~.3f", [max_val])}")
    IO.puts("  Média: #{:io_lib.format("~.3f", [mean])}, Soma: #{:io_lib.format("~.3f", [sum])}")
    IO.puts("")

    %{min: min_val, max: max_val, mean: mean, sum: sum, count: count}
  end

  @doc """
  Prints a matrix in formatted way
  """
  def print_matrix(matrix) do
    for row <- matrix do
      formatted_row = for x <- row do
        :io_lib.format("~.3f", [x])
      end
      |> Enum.join(" ")

      IO.puts("    [#{formatted_row}]")
    end
  end

  @doc """
  Flattens multiple feature maps into a single vector
  """
  def flatten(maps) do
    all_values = maps
    |> Enum.map(&List.flatten/1)
    |> List.flatten()

    case all_values do
      [] -> [0.0]  # Default value if completely empty
      _ -> all_values
    end
  end

  @doc """
  ReLU activation function
  """
  def relu(x) when x > 0, do: x
  def relu(_), do: 0.0

  @doc """
  Sigmoid activation function
  """
  def sigmoid(x) do
    1 / (1 + :math.exp(-x))
  end

  @doc """
  Tanh activation function
  """
  def tanh(x) do
    :math.tanh(x)
  end

  @doc """
  Softmax function
  """
  def softmax(values) do
    max_val = Enum.max(values)
    exp_values = Enum.map(values, &:math.exp(&1 - max_val))
    sum_exp = Enum.sum(exp_values)
    Enum.map(exp_values, &(&1 / sum_exp))
  end

  @doc """
  Dot product of two vectors
  """
  def dot_product(vec1, vec2) do
    vec1
    |> Enum.zip(vec2)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  @doc """
  Matrix multiplication
  """
  def matrix_multiply(matrix_a, matrix_b) do
    rows_a = length(matrix_a)
    cols_a = length(Enum.at(matrix_a, 0))
    cols_b = length(Enum.at(matrix_b, 0))

    for i <- 0..(rows_a - 1) do
      for j <- 0..(cols_b - 1) do
        row_a = Enum.at(matrix_a, i)
        col_b = for k <- 0..(cols_a - 1), do: Enum.at(Enum.at(matrix_b, k), j)
        dot_product(row_a, col_b)
      end
    end
  end

  @doc """
  Formats weights for printing
  """
  def format_weights(weights) do
    weights
    |> Enum.map(&(:io_lib.format("~.3f", [&1])))
    |> Enum.join(", ")
  end

  @doc """
  Creates one-hot encoding vector
  """
  def one_hot_encode(index, size) do
    for i <- 0..(size - 1) do
      if i == index, do: 1.0, else: 0.0
    end
  end

  @doc """
  Calculates mean squared error
  """
  def mean_squared_error(predicted, actual) do
    predicted
    |> Enum.zip(actual)
    |> Enum.map(fn {p, a} -> :math.pow(p - a, 2) end)
    |> Enum.sum()
    |> Kernel./(length(predicted))
  end

  @doc """
  Calculates cross-entropy loss
  """
  def cross_entropy_loss(predicted, actual) do
    epsilon = 1.0e-15  # Small value to prevent log(0)

    predicted
    |> Enum.zip(actual)
    |> Enum.map(fn {p, a} ->
      p_clipped = max(epsilon, min(1.0 - epsilon, p))
      -a * :math.log(p_clipped)
    end)
    |> Enum.sum()
  end

  @doc """
  Applies dropout (randomly sets some values to zero)
  """
  def dropout(vector, dropout_rate) do
    for val <- vector do
      if :rand.uniform() < dropout_rate do
        0.0
      else
        val / (1.0 - dropout_rate)  # Scale remaining values
      end
    end
  end

  @doc """
  Clips values to prevent gradient explosion
  """
  def clip_values(values, min_val, max_val) do
    for val <- values do
      cond do
        val < min_val -> min_val
        val > max_val -> max_val
        true -> val
      end
    end
  end

  @doc """
  Transposes a matrix
  """
  def transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Adds two matrices element-wise
  """
  def matrix_add(matrix_a, matrix_b) do
    matrix_a
    |> Enum.zip(matrix_b)
    |> Enum.map(fn {row_a, row_b} ->
      row_a
      |> Enum.zip(row_b)
      |> Enum.map(fn {a, b} -> a + b end)
    end)
  end

  @doc """
  Subtracts two matrices element-wise
  """
  def matrix_subtract(matrix_a, matrix_b) do
    matrix_a
    |> Enum.zip(matrix_b)
    |> Enum.map(fn {row_a, row_b} ->
      row_a
      |> Enum.zip(row_b)
      |> Enum.map(fn {a, b} -> a - b end)
    end)
  end

  @doc """
  Multiplies matrix by scalar
  """
  def scalar_multiply(matrix, scalar) do
    for row <- matrix do
      for val <- row do
        val * scalar
      end
    end
  end
end

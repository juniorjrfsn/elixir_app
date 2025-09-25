# lib/cnn/matrix.ex
defmodule Cnn.Matrix do
  @moduledoc """
  Module to create and manipulate 5x5 matrices for digits 0-9
  """

  @doc """
  Creates 10 matrices (5x5), one for each digit from 0 to 9
  """
  def create_digit_matrices do
  [
   # Digit 0 (Zero) - Centralized oval
      [
        [0, 0, 1, 1, 1, 0, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 0, 0]
      ],
      # Digit 1 (One) - Centralized, vertical, clear padding
      [
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 0, 0] # Base centralizada e com padding
      ],
      # Digit 2 (Two) - Clear curve and diagonal with side space
      [
        [0, 1, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0],
        [0, 0, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 1, 0]
      ],
      # Digit 3 (Three) - Two clear curves, pulled away from edges
      [
        [0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 0, 0]
      ],
      # Digit 4 (Four) - Strong vertical and horizontal lines
      [
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0],
        [0, 1, 0, 1, 0, 0, 0],
        [1, 0, 0, 1, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0]
      ],
      # Digit 5 (Five) - Clear top, middle, and bottom, with padding
      [
        [0, 1, 1, 1, 1, 1, 0],
        [0, 1, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 1, 1, 1, 1, 0, 0]
      ],
      # Digit 6 (Six) - More defined loop and side space
      [
        [0, 0, 1, 1, 1, 0, 0],
        [0, 1, 0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 0, 0],
        [1, 0, 0, 0, 0, 1, 0],
        [1, 0, 0, 0, 0, 1, 0],
        [0, 1, 1, 1, 1, 0, 0]
      ],
      # Digit 7 (Seven) - Wide top bar and long diagonal
      [
        [1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 1, 0, 0],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0]
      ],
      # Digit 8 (Eight) - Balanced loops with clear borders
      [
        [0, 0, 1, 1, 1, 0, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 0, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 0, 0]
      ],
      # Digit 9 (Nine) - Clear top loop and straight stem
      [
        [0, 0, 1, 1, 1, 0, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 1, 0, 0, 0, 1, 0],
        [0, 0, 1, 1, 1, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 1, 1, 0, 0]
      ]
    ]
  end

  @doc """
  Prints all matrices in a readable format
  """
  def print_matrices(matrices) do
    matrices
    |> Enum.with_index()
    |> Enum.each(fn {matrix, digit} ->
      IO.puts("Matriz para o dígito #{digit}:")
      print_single_matrix(matrix)
      IO.puts("")
    end)
  end

  @doc """
  Prints a single matrix
  """
  def print_single_matrix(matrix) do
    for row <- matrix do
      formatted_row = row |> Enum.map(&to_string/1) |> Enum.join(" ")
      IO.puts("    #{formatted_row}")
    end
  end

  @doc """
  Gets matrix for a specific digit (converted to float)
  """
  def get_digit_matrix(digit) when digit >= 0 and digit <= 9 do
    create_digit_matrices()
    |> Enum.at(digit)
    |> Cnn.Utils.integer_to_float_matrix()
  end

  @doc """
  Gets matrix element safely
  """
  def get_element(matrix, row, col) do
    cond do
      row >= 0 and row < length(matrix) and col >= 0 and col < length(Enum.at(matrix, 0)) ->
        matrix |> Enum.at(row) |> Enum.at(col)
      true ->
        0.0
    end
  end

  @doc """
  Creates a random matrix with given dimensions
  """
  def create_random_matrix(rows, cols) do
    for _ <- 1..rows do
      for _ <- 1..cols do
        (:rand.uniform() - 0.5) * 2
      end
    end
  end

  @doc """
  Creates a random filter for convolution
  """
  def create_random_filter(height, width) do
    for _ <- 1..height do
      for _ <- 1..width do
        (:rand.uniform() - 0.5) * 2
      end
    end
  end
end

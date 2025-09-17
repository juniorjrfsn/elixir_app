# test/cnn/neural_test.exs
defmodule Cnn.NeuralTest do
  use ExUnit.Case

  describe "edge density" do
    setup do
      {:ok, matrix: [
        [5, 4, 3, 2, 1],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [1, 2, 3, 4, 5]
      ]}
    end

    test "top_edge_density", %{matrix: matrix} do
      assert Cnn.Neural.top_edge_density(matrix) == 3.0  # (5+4+3+2+1)/5 = 15/5 = 3.0
    end

    test "bottom_edge_density", %{matrix: matrix} do
      assert Cnn.Neural.bottom_edge_density(matrix) == 3.0  # (1+2+3+4+5)/5 = 15/5 = 3.0
    end
  end
end

defmodule Neuron do
  defstruct weights: [], bias: 0.0

  # Initialize a new neuron with random weights and bias
  def new(num_inputs) do
    bound = :math.sqrt(6.0 / (num_inputs + 1))
    weights = Enum.map(1..num_inputs, fn _ -> :rand.uniform() * 2 * bound - bound end)
    bias = :rand.uniform() * 2 * bound - bound
    %__MODULE__{weights: weights, bias: bias}
  end

  # Activate the neuron with given inputs and activation function
  def activate(%__MODULE__{weights: weights, bias: bias}, inputs, activation_fn) do
    sum =
      Enum.zip(weights, inputs)
      |> Enum.map(fn {w, x} -> w * x end)
      |> Enum.sum()
      |> Kernel.+(bias)

    case activation_fn do
      :tanh -> :math.tanh(sum)
      :sigmoid -> 1.0 / (1.0 + :math.exp(-sum))
      _ -> raise "Unsupported activation function"
    end
  end
end

defmodule MLP do
  defstruct layers: []

  # Initialize a new MLP with given layer sizes
  def new(layer_sizes) do
    layers =
      Enum.chunk_every(layer_sizes, 2, 1, :discard)
      |> Enum.map(fn [num_inputs, num_neurons] ->
        Enum.map(1..num_neurons, fn _ -> Neuron.new(num_inputs) end)
      end)

    %__MODULE__{layers: layers}
  end

  # Perform a forward pass through the network
  def forward(%__MODULE__{layers: layers}, inputs) do
    Enum.reduce(layers, [inputs], fn layer, activations ->
      activation_fn = if layer == List.last(layers), do: :sigmoid, else: :tanh
      new_activations =
        Enum.map(layer, fn neuron ->
          Neuron.activate(neuron, List.flatten(List.last(activations)), activation_fn)
        end)
      activations ++ [new_activations]
    end)
  end

  # Train the network using backpropagation
  def train(mlp, training_data, learning_rate, epochs) do
    Enum.reduce(1..epochs, mlp, fn epoch, current_mlp ->
      {total_error, updated_mlp} =
        Enum.reduce(training_data, {0.0, current_mlp}, fn {inputs, targets}, {error_acc, mlp_acc} ->
          # Forward pass
          activations = forward(mlp_acc, inputs)
          output = List.flatten(List.last(activations))

          # Calculate output error (MSE)
          output_errors = Enum.zip(output, targets)
                          |> Enum.map(fn {o, t} -> t - o end)
          total_error = error_acc + Enum.sum(Enum.map(output_errors, fn e -> e * e end))

          # Backpropagation
          deltas =
            Enum.reduce(Enum.reverse(mlp_acc.layers), {[], activations}, fn layer, {deltas_acc, act_acc} ->
              prev_activations = List.flatten(List.first(act_acc))
              act_acc = tl(act_acc)

              if deltas_acc == [] do
                # Output layer deltas
                output_deltas =
                  Enum.zip(output_errors, output)
                  |> Enum.map(fn {err, out} -> err * out * (1.0 - out) end) # Sigmoid derivative
                {[output_deltas | deltas_acc], act_acc}
              else
                # Hidden layer deltas
                layer_deltas =
                  Enum.map(layer, fn neuron ->
                    delta_sum =
                      Enum.zip(deltas_acc, neuron.weights)
                      |> Enum.map(fn {delta, w} -> delta * w end)
                      |> Enum.sum()

                    activation = List.flatten(prev_activations)
                    delta_sum * (1.0 - activation * activation) # Tanh derivative
                  end)

                {[layer_deltas | deltas_acc], act_acc}
              end
            end)
            |> elem(0)

          # Update weights and biases
          updated_layers =
            Enum.zip(mlp_acc.layers, deltas)
            |> Enum.map(fn {layer, deltas_layer} ->
              Enum.map(Enum.zip(layer, deltas_layer), fn {neuron, delta} ->
                # Ensure activations are scalars
                prev_activations = List.flatten(List.first(activations))

                updated_weights =
                  Enum.zip(neuron.weights, prev_activations)
                  |> Enum.map(fn {w, a} -> w + learning_rate * delta * a end)

                %{neuron | weights: updated_weights, bias: neuron.bias + learning_rate * delta}
              end)
            end)

          {total_error, %{mlp_acc | layers: updated_layers}}
        end)

      avg_error = total_error / length(training_data)
      IO.puts("Epoch #{epoch}: Average Error = #{avg_error}")
      updated_mlp
    end)
  end
end

# Main function to test the MLP
defmodule Main do
  def run do
    layer_sizes = [2, 3, 1]
    mlp = MLP.new(layer_sizes)

    training_data = [
      {[0.0, 0.0], [0.0]},
      {[0.0, 1.0], [1.0]},
      {[1.0, 0.0], [1.0]},
      {[1.0, 1.0], [0.0]}
    ]

    trained_mlp = MLP.train(mlp, training_data, 0.1, 50000)

    IO.puts("\nTest Results:")
    Enum.each([[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]], fn input ->
      output = MLP.forward(trained_mlp, input) |> List.flatten() |> List.last()
      IO.puts("Input: #{inspect(input)}, Predicted Output: #{Float.round(output, 4)}")
    end)
  end
end

Main.run()

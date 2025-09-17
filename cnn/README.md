# Cnn

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cnn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cnn, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/cnn>.


Estrutura dos Arquivos:

lib/cnn.ex - Módulo principal que orquestra toda a aplicação
lib/cnn/matrix.ex - Criação e manipulação das matrizes 5x5 dos dígitos 0-9
lib/cnn/neural.ex - Implementação da rede neural convolucional
lib/cnn/conv_ops.ex - Operações convolucionais (convolução, pooling, etc.)
lib/cnn/utils.ex - Utilitários para manipulação de matrizes e funções matemáticas
lib/cnn/application.ex - Aplicação OTP com modo interativo e benchmarks
mix.exs - Configuração do projeto com CLI integrado

Principais Melhorias:
Arquitetura Elixir:

Modularização limpa: Cada responsabilidade em seu módulo
Structs tipados: Para camadas neurais (ConvLayer, FCLayer)
Pattern matching: Uso extensivo para controle de fluxo
Pipes: Para operações funcionais encadeadas
OTP Application: Estrutura padrão Elixir

Funcionalidades Mantidas:

✅ CNN completa (2 camadas conv + 2 fully connected)
✅ Classificação de dígitos 0-9 (matrizes 5x5)
✅ Operações de convolução e max pooling
✅ Funções de ativação (ReLU, Softmax)
✅ Teste com ruído
✅ Estatísticas e benchmarks
✅ Modo interativo

Funcionalidades Adicionais:

CLI integrado: Execute como escript (mix escript.build && ./cnn)
Modo interativo: Teste diferentes configurações
Benchmark detalhado: Performance de múltiplas execuções
Estatísticas da rede: Contagem de parâmetros e arquitetura
Utilitários matemáticos: Mais funções para ML (dropout, clipping, etc.)

Como Usar:
bash# Compilar
mix compile

# Executar programa principal
mix run -e "Cnn.main()"

# Executar todos os testes
mix run -e "Cnn.run_tests()"

# Testar dígito específico
mix run -e "Cnn.test_digit(5)"

# Testar com ruído
mix run -e "Cnn.test_digit(5, 0.2)"

# Modo interativo
mix run -e "Cnn.Application.interactive_mode()"

# Gerar executável
mix escript.build
./cnn interactive
O


📊 Fluxo de Processos e Dados do Sistema
flowchart TD

%% Entrada
A[Usuário via CLI ou Modo Interativo] -->|comando| B[Cnn.Application / Cnn.CLI]

%% Orquestração
B -->|executa| C[Cnn (Módulo Principal)]

%% Criação de Dados
C --> D[Cnn.Matrix.create_digit_matrices]
D -->|gera| E[Matrizes 5x5 dos dígitos 0–9]

%% Criação da Rede
C --> F[Cnn.Neural.create_network]
F -->|estruturas| G[Conv1, Conv2, FC1, FC2]

%% Treinamento
C --> H[Cnn.Neural.train_network]
E --> H
H -->|rede treinada| I[Neural Network Treinada]

%% Testes
C --> J[Cnn.Neural.test_network_patterns]
I --> J
E --> J
J -->|Predição e Confiança| K[Resultados dos Testes]

%% Alternativas de Predição
I --> L[Cnn.Neural.predict]
I --> M[Cnn.Neural.predict_with_patterns]

%% Operações de Camadas
L --> N[Cnn.ConvOps]
M --> N
N -->|Conv, Pooling, ReLU| O[Mapas de Características]

%% Funções de Apoio
E --> P[Cnn.Utils]
F --> P
H --> P
J --> P
L --> P
M --> P
N --> P

%% Saída
K --> Q[Saída no Console: Estatísticas, Benchmarks, Resultados]

🔎 Explicação por Etapas

Entrada (CLI / Interativo)

O usuário interage via Cnn.CLI (mix escript.build && ./cnn) ou modo interativo (Cnn.Application.interactive_mode).

Possibilidades: rodar main, test_all, test_N, noise_test, benchmark, stats.

Orquestração (Cnn.ex)

Responsável por coordenar:

Criação das matrizes dos dígitos (Matrix).

Criação e inicialização da rede (Neural).

Treinamento (train_network).

Testes (test_network_patterns ou predict).

Estatísticas e benchmarks.

Dados de Entrada (Matrix)

create_digit_matrices/0: gera representações fixas 5x5 para cada dígito (0–9).

Pode aplicar conversões (integer_to_float_matrix/1), normalização ou ruído.

Criação da Rede (Neural)

Rede definida em structs:

ConvLayer: filtros 3x3 + bias.

FCLayer: pesos + bias.

Inicialização Xavier para pesos.

Treinamento (train_network)

Método baseado em assinaturas de padrões (features extraídas de cada dígito).

Atualiza biases das camadas totalmente conectadas.

Predição (Neural)

Dois modos:

predict/2: extração estatística de features + forward em FC1 → FC2 → Softmax.

predict_with_patterns/3: comparação direta com matrizes de treino (similaridade).

Ambos retornam probabilidades para cada dígito.

Operações Convolucionais (ConvOps)

conv_forward/3, convolve_2d/3, max_pool/2.

Aplicação de ReLU, padding e stride.

Usado dentro da pipeline para gerar mapas de características.

Funções Utilitárias (Utils)

Normalização, dropout, clipping, softmax, estatísticas de matrizes.

Operações matemáticas (dot product, matrix multiply, transpose).

Saída (Console)

Resultados:

Matrizes de dígitos.

Pesos da rede.

Predições com confiança (%).

Estatísticas de acurácia.

Benchmarks de tempo (treinamento e inferência).


🧠 Arquitetura da CNN
flowchart TD

%% Entrada
A[Entrada: Matriz 5x5 (25 pixels)] --> B[Conv1: 4 filtros 3x3 + ReLU]

B --> C[Pool1: MaxPooling 2x2]
C --> D[Conv2: 8 filtros 3x3 + ReLU]

D --> E[Pool2: MaxPooling 2x2]
E --> F[Flatten: vetor de características (~8 elementos)]

F --> G[FC1: Camada totalmente conectada (16 neurônios, ReLU)]
G --> H[FC2: Camada de saída (10 neurônios)]

H --> I[Softmax → Probabilidades para dígitos 0–9]

📐 Explicação da Arquitetura

Entrada (5x5 = 25 pixels)
Cada dígito é representado como uma matriz 5x5 de 0 e 1.

Conv1 (4 filtros 3x3 + ReLU)

Gera 4 feature maps 3x3.

Ativação ReLU aplicada a cada saída.

Pool1 (MaxPooling 2x2)

Reduz cada mapa para dimensões menores (compressão de informação).

Conv2 (8 filtros 3x3 + ReLU)

Aplica 8 filtros sobre os mapas da Pool1.

Extrai padrões mais complexos.

Pool2 (MaxPooling 2x2)

Reduz novamente os mapas.

Saída pronta para “achatar”.

Flatten

Transforma os mapas resultantes em um vetor 1D (~8 valores).

FC1 (16 neurônios, ReLU)

Primeira camada densa.

Combina as features em representações abstratas.

FC2 (10 neurônios)

Camada final.

Cada neurônio corresponde a um dígito (0–9).

Softmax

Converte as saídas em probabilidades normalizadas.

Resultado final = dígito mais provável.
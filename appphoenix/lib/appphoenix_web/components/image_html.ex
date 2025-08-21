defmodule AppphoenixWeb.ImageHTML do
  use AppphoenixWeb, :html

  # Import necessário para form_for e submit
  import Phoenix.HTML.Form

  embed_templates("image_html/*")

  # Helper para formatar tamanho do arquivo
  def format_file_size(bytes) when is_integer(bytes) do
    cond do
      bytes >= 1_048_576 -> "#{Float.round(bytes / 1_048_576, 1)} MB"
      bytes >= 1024 -> "#{Float.round(bytes / 1024, 1)} KB"
      true -> "#{bytes} B"
    end
  end

  # Helper para formatar data/hora
  def format_datetime({{year, month, day}, {hour, minute, second}}) do
    "#{day}/#{month}/#{year} #{hour}:#{minute}:#{second}"
  end

  def format_datetime(datetime) when is_tuple(datetime) do
    format_datetime(datetime)
  end

  def format_datetime(_), do: "Unknown"
end

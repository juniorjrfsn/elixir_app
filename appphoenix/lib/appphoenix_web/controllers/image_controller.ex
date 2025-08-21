defmodule AppphoenixWeb.ImageController do
  use AppphoenixWeb, :controller
  require Logger

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"image" => %{"file" => upload, "name" => name}}) do
    case handle_image_upload(upload, name) do
      {:ok, image_info} ->
        conn
        |> put_flash(:info, "Image uploaded successfully as #{image_info.filename}")
        |> redirect(to: "/gallery")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Upload failed: #{reason}")
        |> redirect(to: "/upload")
    end
  end

  def create(conn, _) do
    conn
    |> put_flash(:error, "Invalid upload data")
    |> redirect(to: "/upload")
  end

  # Lista todas as imagens salvas (útil para deep learning)
  def list(conn, _params) do
    images = get_uploaded_images()
    json(conn, %{images: images})
  end

  # Endpoint para processar deep learning em lote
  def process_batch(conn, _params) do
    images = get_uploaded_images()

    # Aqui você pode chamar seu modelo de deep learning
    # results = YourDeepLearningModule.process_images(images)

    json(conn, %{
      message: "Batch processing initiated",
      image_count: length(images),
      images: images
    })
  end

  # Funções privadas
  defp handle_image_upload(upload, name) do
    with {:ok, upload_dir} <- ensure_upload_directory(),
         {:ok, filename} <- generate_filename(upload, name),
         {:ok, file_path} <- save_file(upload, upload_dir, filename),
         {:ok, metadata} <- extract_metadata(file_path, filename) do

      # Log para auditoria
      Logger.info("Image uploaded: #{filename}, size: #{metadata.size} bytes")

      # Salvar metadados no banco (opcional - você precisaria criar uma tabela)
      # save_image_metadata(metadata)

      {:ok, metadata}
    else
      error -> error
    end
  end

  defp ensure_upload_directory do
    upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")

    case File.mkdir_p(upload_dir) do
      :ok -> {:ok, upload_dir}
      {:error, reason} -> {:error, "Failed to create upload directory: #{reason}"}
    end
  end

  defp generate_filename(upload, name) do
    ext = Path.extname(upload.filename)

    # Validar extensão
    if valid_image_extension?(ext) do
      filename = if name != "" and String.trim(name) != "" do
        # Sanitizar o nome para evitar problemas
        sanitized_name = sanitize_filename(name)
        "#{sanitized_name}#{ext}"
      else
        # Gerar nome único se não fornecido
        timestamp = DateTime.utc_now() |> DateTime.to_unix()
        "image_#{timestamp}#{ext}"
      end

      {:ok, filename}
    else
      {:error, "Invalid image format. Supported: jpg, jpeg, png, gif, webp"}
    end
  end

  defp valid_image_extension?(ext) do
    String.downcase(ext) in [".jpg", ".jpeg", ".png", ".gif", ".webp"]
  end

  defp sanitize_filename(name) do
    name
    |> String.trim()
    |> String.replace(~r/[^a-zA-Z0-9_-]/, "_")
    |> String.slice(0, 50) # Limitar tamanho
  end

  defp save_file(upload, upload_dir, filename) do
    file_path = Path.join(upload_dir, filename)

    # Verificar se arquivo já existe
    if File.exists?(file_path) do
      {:error, "File with this name already exists"}
    else
      case File.cp(upload.path, file_path) do
        :ok -> {:ok, file_path}
        {:error, reason} -> {:error, "Failed to save file: #{reason}"}
      end
    end
  end

  defp extract_metadata(file_path, filename) do
    with {:ok, stat} <- File.stat(file_path) do
      metadata = %{
        filename: filename,
        path: file_path,
        size: stat.size,
        uploaded_at: DateTime.utc_now(),
        content_type: get_content_type(filename),
        ready_for_processing: true
      }

      {:ok, metadata}
    else
      {:error, reason} -> {:error, "Failed to read file metadata: #{reason}"}
    end
  end

  defp get_content_type(filename) do
    case String.downcase(Path.extname(filename)) do
      ".jpg" -> "image/jpeg"
      ".jpeg" -> "image/jpeg"
      ".png" -> "image/png"
      ".gif" -> "image/gif"
      ".webp" -> "image/webp"
      _ -> "application/octet-stream"
    end
  end

  defp get_uploaded_images do
    upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")

    case File.ls(upload_dir) do
      {:ok, files} ->
        files
        |> Enum.filter(&valid_image_extension?(Path.extname(&1)))
        |> Enum.map(fn filename ->
          file_path = Path.join(upload_dir, filename)
          {:ok, stat} = File.stat(file_path)

          %{
            filename: filename,
            path: file_path,
            size: stat.size,
            modified: stat.mtime,
            url: "/uploads/#{filename}"
          }
        end)
        |> Enum.sort_by(& &1.modified, {:desc, DateTime})

      {:error, _} -> []
    end
  end

  # No seu image_controller.ex, adicione estas funções:

def process_single(conn, %{"filename" => filename}) do
  upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")
  image_path = Path.join(upload_dir, filename)

  case Appphoenix.DeepLearning.process_image(image_path) do
    {:ok, result} ->
      # Salvar resultados
      Appphoenix.DeepLearning.save_results(image_path, result)

      json(conn, %{
        status: "success",
        filename: filename,
        result: result
      })

    {:error, reason} ->
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{status: "error", message: reason})
  end
end

def get_results(conn, %{"filename" => filename}) do
  upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")
  image_path = Path.join(upload_dir, filename)

  case Appphoenix.DeepLearning.load_results(image_path) do
    {:ok, results} ->
      json(conn, %{status: "success", results: results})

    {:error, reason} ->
      conn
      |> put_status(:not_found)
      |> json(%{status: "error", message: reason})
  end
end

    def gallery(conn, _params) do
      images = get_uploaded_images()
      render(conn, :gallery, images: images)
    end

    def show(conn, %{"filename" => filename}) do
      upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")
      image_path = Path.join(upload_dir, filename)

      if File.exists?(image_path) do
        conn
        |> put_resp_content_type("image/jpeg") # ou detectar tipo automaticamente
        |> send_file(200, image_path)
      else
        conn
        |> put_status(:not_found)
        |> text("Image not found")
      end
    end

    defp get_uploaded_images do
      upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")

      case File.ls(upload_dir) do
        {:ok, files} ->
          Enum.filter(files, fn file ->
            String.downcase(Path.extname(file)) in [".jpg", ".jpeg", ".png", ".gif", ".webp"]
          end)
        {:error, _} -> []
      end
    end
end

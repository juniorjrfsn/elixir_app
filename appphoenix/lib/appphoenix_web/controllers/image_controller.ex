defmodule AppphoenixWeb.ImageController do
  use AppphoenixWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"image" => %{"file" => upload, "name" => name}}) do
    # Ensure uploads directory exists
    upload_dir = Path.join(:code.priv_dir(:appphoenix), "static/uploads")
    File.mkdir_p!(upload_dir)

    # Generate filename with original extension
    ext = Path.extname(upload.filename)
    filename = if name != "", do: "#{name}#{ext}", else: upload.filename
    path = Path.join(upload_dir, filename)

    # Copy the uploaded file
    File.cp!(upload.path, path)

    conn
    |> put_flash(:info, "Image uploaded successfully as #{filename}")
    |> redirect(to: "/")
  end

  def create(conn, _) do
    conn
    |> put_flash(:error, "Invalid upload data")
    |> redirect(to: "/upload")
  end
end

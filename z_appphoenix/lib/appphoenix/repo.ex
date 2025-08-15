defmodule Appphoenix.Repo do
  use Ecto.Repo,
    otp_app: :appphoenix,
    adapter: Ecto.Adapters.Postgres
end

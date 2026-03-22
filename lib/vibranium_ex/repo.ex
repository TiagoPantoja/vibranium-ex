defmodule VibraniumEx.Repo do
  use Ecto.Repo,
    otp_app: :vibranium_ex,
    adapter: Ecto.Adapters.Postgres
end

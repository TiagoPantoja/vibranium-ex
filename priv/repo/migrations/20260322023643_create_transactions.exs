defmodule VibraniumEx.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal
      add :price, :decimal
      add :buyer_id, references(:users, on_delete: :nothing)
      add :seller_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:buyer_id])
    create index(:transactions, [:seller_id])
  end
end

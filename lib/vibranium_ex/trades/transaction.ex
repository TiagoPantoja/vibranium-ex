defmodule VibraniumEx.Trades.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :price, :decimal
    field :buyer_id, :id
    field :seller_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :price])
    |> validate_required([:amount, :price])
  end
end

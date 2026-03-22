defmodule VibraniumEx.Warehouse.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stocks" do
    field :amount, :decimal
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end

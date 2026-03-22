defmodule Vibranium.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :balance, :decimal
    has_one :stock, Vibranium.Warehouse.Stock
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :balance])
    |> validate_required([:name, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end

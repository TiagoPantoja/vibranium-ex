defmodule Vibranium.Trades do
  alias Vibranium.Repo
  alias Vibranium.Accounts.User
  alias Vibranium.Warehouse.Stock
  alias Vibranium.Trades.Transaction
  alias Ecto.Multi

  def execute_vibranium_trade(buyer_id, seller_id, amount, unit_price) do
    total_price = Decimal.mult(amount, unit_price)

    Multi.new()
    |> Multi.update(:debit_buyer, User.debit_query(buyer_id, total_price))
    |> Multi.update(:credit_seller, User.credit_query(seller_id, total_price))
    |> Multi.update(:remove_stock, Stock.remove_query(seller_id, amount))
    |> Multi.update(:add_stock, Stock.add_query(buyer_id, amount))
    |> Multi.insert(:record_transaction, %Transaction{
      buyer_id: buyer_id,
      seller_id: seller_id,
      amount: amount,
      price: unit_price
    })
    |> Repo.transaction()
  end
end

defmodule Vibranium.Trades.OrderService do
  alias Ecto.Multi
  alias Vibranium.Repo
  alias Vibranium.Accounts.RepoUtils, as: UserRepo
  alias Vibranium.Warehouse.RepoUtils, as: StockRepo

  def process_trade(buyer_id, seller_id, amount, price) do
    total = Decimal.mult(amount, price)

    Multi.new()
    |> Multi.update_all(:debit_buyer, UserRepo.debit_query(buyer_id, total), [])
    |> Multi.update_all(:credit_seller, UserRepo.credit_query(seller_id, total), [])
    |> Multi.update_all(:remove_vibranium, StockRepo.remove_query(seller_id, amount), [])
    |> Multi.update_all(:add_vibranium, StockRepo.add_query(buyer_id, amount), [])
    |> Multi.insert(:audit_log, %Vibranium.Trades.Transaction{...})
    |> Repo.transaction()
    |> handle_transaction_result()
  end

  defp handle_transaction_result({:ok, _}), do: :ok

  defp handle_transaction_result({:error, _, _, _}),
    do: {:error, "Falha na transação: Saldo ou estoque insuficiente"}
end

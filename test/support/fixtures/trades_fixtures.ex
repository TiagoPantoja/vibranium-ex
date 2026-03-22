defmodule VibraniumEx.TradesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VibraniumEx.Trades` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        price: "120.5"
      })
      |> VibraniumEx.Trades.create_transaction()

    transaction
  end
end

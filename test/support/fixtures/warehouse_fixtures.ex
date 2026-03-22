defmodule VibraniumEx.WarehouseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VibraniumEx.Warehouse` context.
  """

  @doc """
  Generate a stock.
  """
  def stock_fixture(attrs \\ %{}) do
    {:ok, stock} =
      attrs
      |> Enum.into(%{
        amount: "120.5"
      })
      |> VibraniumEx.Warehouse.create_stock()

    stock
  end
end

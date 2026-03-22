defmodule VibraniumEx.WarehouseTest do
  use VibraniumEx.DataCase

  alias VibraniumEx.Warehouse

  describe "stocks" do
    alias VibraniumEx.Warehouse.Stock

    import VibraniumEx.WarehouseFixtures

    @invalid_attrs %{amount: nil}

    test "list_stocks/0 returns all stocks" do
      stock = stock_fixture()
      assert Warehouse.list_stocks() == [stock]
    end

    test "get_stock!/1 returns the stock with given id" do
      stock = stock_fixture()
      assert Warehouse.get_stock!(stock.id) == stock
    end

    test "create_stock/1 with valid data creates a stock" do
      valid_attrs = %{amount: "120.5"}

      assert {:ok, %Stock{} = stock} = Warehouse.create_stock(valid_attrs)
      assert stock.amount == Decimal.new("120.5")
    end

    test "create_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehouse.create_stock(@invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock" do
      stock = stock_fixture()
      update_attrs = %{amount: "456.7"}

      assert {:ok, %Stock{} = stock} = Warehouse.update_stock(stock, update_attrs)
      assert stock.amount == Decimal.new("456.7")
    end

    test "update_stock/2 with invalid data returns error changeset" do
      stock = stock_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehouse.update_stock(stock, @invalid_attrs)
      assert stock == Warehouse.get_stock!(stock.id)
    end

    test "delete_stock/1 deletes the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{}} = Warehouse.delete_stock(stock)
      assert_raise Ecto.NoResultsError, fn -> Warehouse.get_stock!(stock.id) end
    end

    test "change_stock/1 returns a stock changeset" do
      stock = stock_fixture()
      assert %Ecto.Changeset{} = Warehouse.change_stock(stock)
    end
  end
end

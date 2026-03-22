defmodule VibraniumEx.TradesTest do
  use VibraniumEx.DataCase

  alias VibraniumEx.Trades

  describe "transactions" do
    alias VibraniumEx.Trades.Transaction

    import VibraniumEx.TradesFixtures

    @invalid_attrs %{amount: nil, price: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Trades.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Trades.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{amount: "120.5", price: "120.5"}

      assert {:ok, %Transaction{} = transaction} = Trades.create_transaction(valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.price == Decimal.new("120.5")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trades.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{amount: "456.7", price: "456.7"}

      assert {:ok, %Transaction{} = transaction} = Trades.update_transaction(transaction, update_attrs)
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.price == Decimal.new("456.7")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Trades.update_transaction(transaction, @invalid_attrs)
      assert transaction == Trades.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Trades.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Trades.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Trades.change_transaction(transaction)
    end
  end
end

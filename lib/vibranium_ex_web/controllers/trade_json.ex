defmodule VibraniumWeb.TradeJSON do
  def show(%{trade: trade}) do
    %{
      id: trade.uuid,
      vibranium_amount: "#{trade.amount}mg",
      status: "EXECUTED",
      timestamp: DateTime.utc_now()
    }
  end
end

defmodule VibraniumWeb.TradeController do
  use VibraniumWeb, :controller
  alias Vibranium.Messaging.Publisher

  def create(conn, %{"order" => order_params}) do
    case Publisher.publish_order(order_params) do
      :ok ->
        conn
        |> put_status(:accepted)
        |> json(%{message: "Ordem de Vibranium enviada para processamento"})

      {:error, _reason} ->
        conn
        |> put_status(:service_unavailable)
        |> json(%{error: "Sistema de mensageria offline"})
    end
  end
end

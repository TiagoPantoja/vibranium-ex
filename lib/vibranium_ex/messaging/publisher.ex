defmodule Vibranium.Messaging.Publisher do
  @queue "vibranium_trades_queue"

  def publish_order(order_params) do
    with {:ok, conn} <- AMQP.Connection.open(),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      AMQP.Queue.declare(chan, @queue, durable: true)

      payload = Jason.encode!(order_params)

      AMQP.Basic.publish(chan, "", @queue, payload, persistent: true)

      AMQP.Connection.close(conn)
      :ok
    else
      {:error, reason} ->
        {:error, "Falha na mensageria: #{inspect(reason)}"}
    end
  end
end

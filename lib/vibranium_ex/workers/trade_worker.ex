defmodule Vibranium.Workers.TradeWorker do
  use GenServer
  require Logger
  alias Vibranium.Trades.OrderService

  @queue "vibranium_trades_queue"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    case AMQP.Connection.open() do
      {:ok, conn} ->
        {:ok, chan} = AMQP.Channel.open(conn)
        AMQP.Queue.declare(chan, @queue, durable: true)

        AMQP.Basic.qos(chan, prefetch_count: 1)

        AMQP.Basic.consume(chan, @queue)

        Logger.info("TradeWorker aguardando ordens de Vibranium")
        {:ok, %{channel: chan}}

      {:error, _} ->
        Logger.error("Falha ao conectar no RabbitMQ. Tentando novamente em 5s")
        :timer.send_after(5000, :reconnect)
        {:ok, %{channel: nil}}
    end
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag}}, state) do
    spawn(fn ->
      process_message(payload)
      AMQP.Basic.ack(state.channel, tag)
    end)

    {:noreply, state}
  end

  defp process_message(payload) do
    data = Jason.decode!(payload)

    case OrderService.process_trade(
           data["buyer_id"],
           data["seller_id"],
           data["amount"],
           data["price"]
         ) do
      :ok ->
        Logger.info("Transação de Vibranium executada: #{payload}")

      {:error, reason} ->
        Logger.error("Falha na transação: #{reason}")
    end
  end

  def handle_info(:reconnect, _state), do: init(%{})
end

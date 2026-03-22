# VibraniumEX: High-Availability Trade System

O **VibraniumEX** é um ecossistema de alta performance para negociação de minérios raros. O projeto foi desenhado para simular um ambiente de missão crítica, priorizando a resiliência e a consistência dos dados através de uma arquitetura baseada em eventos.

## Arquitetura e Engenharia

VibraniumEX utiliza um modelo assíncrono para garantir que nenhuma ordem de compra seja perdida, mesmo sob carga extrema:

1.  **API Gateway (Phoenix):** Recebe as ordens de compra/venda e valida o schema.
2.  **Message Broker (RabbitMQ):** Atua como buffer persistente, desacoplando a recepção do processamento.
3.  **Worker (GenServer):** Consumidor resiliente que processa as ordens da fila de forma isolada.
4.  **Domain Logic (Ecto.Multi):** Garante a atomicidade (ACID) das transações, impedindo double-spending ou falhas de estoque.

## Tecnologias Utilizadas

* **Linguagem:** Elixir 1.16 (BEAM VM)
* **Framework Web:** Phoenix 1.7
* **Banco de Dados:** PostgreSQL 15 (Persistência Relacional)
* **Mensageria:** RabbitMQ (AMQP Protocol)
* **Containerização:** Docker & Docker-Compose
* **Bibliotecas Chave:** `amqp` (RabbitMQ Client), `jason` (JSON Parsing), `money` (Precisão Decimal).

## Como Rodar o Projeto

### Pré-requisitos
* Docker e Docker-Compose instalados.
* Elixir 1.16 se desejar rodar fora do container.

### Passo a Passo

1.  **Subir todo o ecossistema (API + DB + MQ):**
    ```bash
    docker compose up --build -d
    ```

2.  **Preparar o Banco de Dados:**
    ```bash
    docker compose exec app mix ecto.setup
    ```

3.  **Acessar o Dashboard do RabbitMQ:**
    Abra `http://localhost:15672` (User/Pass: `guest`) para monitorar a fila `vibranium_trades_queue`.

## Testando os Endpoints

### 1. Criar uma Ordem de Compra
Este endpoint é **assíncrono**. Ele retornará `202 Accepted` assim que a ordem for postada com sucesso no RabbitMQ.

* **URL:** `POST http://localhost:4000/api/trades`
* **Payload:**
```json
{
  "order": {
    "buyer_id": 1,
    "seller_id": 2,
    "amount": "10.5",
    "price": "1500.00"
  }
}

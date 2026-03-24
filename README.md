# VibraniumEX: High-Availability Trade System

**VibraniumEX** is a high-performance ecosystem for trading rare minerals. The project was designed to simulate a mission-critical environment, prioritizing resilience and data consistency through an event-driven architecture.

## Architecture and Engineering

VibraniumEX uses an asynchronous model to ensure that no buy order is lost, even under extreme load:

1. **API Gateway (Phoenix):** Receives buy/sell orders and validates the schema.  
2. **Message Broker (RabbitMQ):** Acts as a persistent buffer, decoupling reception from processing.  
3. **Worker (GenServer):** A resilient consumer that processes queue orders in isolation.  
4. **Domain Logic (Ecto.Multi):** Ensures transaction atomicity (ACID), preventing double-spending or inventory failures.  

## Technologies Used

* **Language:** Elixir 1.16 (BEAM VM)  
* **Web Framework:** Phoenix 1.7  
* **Database:** PostgreSQL 15 (Relational Persistence)  
* **Messaging:** RabbitMQ (AMQP Protocol)  
* **Containerization:** Docker & Docker Compose  
* **Key Libraries:** `amqp` (RabbitMQ Client), `jason` (JSON Parsing), `money` (Decimal Precision).  

## How to Run the Project

### Prerequisites
* Docker and Docker Compose installed  
* Elixir 1.16 if you want to run it outside the container  

### Step-by-Step

1. **Start the entire ecosystem (API + DB + MQ):**
```bash
docker compose up --build -d
```

2. **Prepare the Database:**
```bash
docker compose exec app mix ecto.setup
```

3. **Access the RabbitMQ Dashboard:**
Open `http://localhost:15672` (User/Pass: `guest`) to monitor the `vibranium_trades_queue`.

## Testing the Endpoints
1. **Create a Buy Order*
This endpoint is asynchronous. It will return `202 Accepted` as soon as the order is succesfully posted to RabbitMQ.

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

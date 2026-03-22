defmodule Vibranium.Accounts.RepoUtils do
  import Ecto.Query
  alias Vibranium.Accounts.User

  def debit_query(user_id, amount) do
    from(u in User,
      where: u.id == ^user_id and u.balance >= ^amount,
      update: [inc: [balance: ^Decimal.negate(amount)]]
    )
  end

  def credit_query(user_id, amount) do
    from(u in User,
      where: u.id == ^user_id,
      update: [inc: [balance: ^amount]]
    )
  end
end

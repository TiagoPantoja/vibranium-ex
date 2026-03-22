defmodule VibraniumEx.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VibraniumEx.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: "120.5",
        name: "some name"
      })
      |> VibraniumEx.Accounts.create_user()

    user
  end
end

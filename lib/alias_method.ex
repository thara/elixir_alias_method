defmodule AliasMethod do
  @moduledoc """
    Implementation of Walker's Alias method by Elixir.
    The algorithm is principally useful when you need to random sampling with replacement by O(1).

    ## Examples

        iex> weights = [1, 1, 8]
        iex> table = AliasMethod.generate_table(weights)
        iex> table
        %AliasMethod.Table{alias_table: %{0 => 2, 1 => 2, 2 => 0}, length: 3, probability_table: %{0 => 0.3, 1 => 0.3, 2 => 1.0}}
        iex> n = AliasMethod.choice(table)
        iex> 0 <= n && n <= table.length
        true
  """
  alias AliasMethod.Table

  @doc """
    Generate Table by weights.
  """
  @spec generate_table(list(float)) :: Table.t()
  def generate_table(weights), do: Table.generate(weights)

  @doc """
    Choice a index from passed Table at random.
  """
  @spec choice(Table.t()) :: integer
  def choice(table), do: Table.choice(table)
end

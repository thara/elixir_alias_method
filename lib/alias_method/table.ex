defmodule AliasMethod.Table do
  @moduledoc """
    struct represents probability table and alias table generated by weights
  """
  @type t :: %__MODULE__{
          length: integer,
          probability_table: %{integer => number},
          alias_table: %{integer => number}
        }

  defstruct [:length, :probability_table, :alias_table]

  @spec generate(list(float)) :: t()
  def generate(weights), do: do_generate(weights, weights |> Enum.sum())

  @spec choice(t()) :: integer
  def choice(table) do
    u = :rand.uniform()
    n = 0..(table.length - 1) |> Enum.random()

    if u <= Map.fetch!(table.probability_table, n) do
      n
    else
      Map.fetch!(table.alias_table, n)
    end
  end

  defp do_generate(_, sum) when sum == 0, do: %__MODULE__{}

  defp do_generate(weights, sum) do
    n = weights |> Enum.count()

    prob = weights |> Enum.map(&(&1 * n / sum))
    short = prob |> indexes_by(&(&1 <= 1.0))
    long = prob |> indexes_by(&(&1 > 1.0)) |> Enum.reverse()

    p_table = prob |> to_index_map
    a_table = Enum.to_list(0..(n - 1)) |> Enum.map(&{&1, 0}) |> Map.new()

    {p_table, a_table} = r_gen_tables(short, long, p_table, a_table)
    %__MODULE__{length: n, probability_table: p_table, alias_table: a_table}
  end

  defp r_gen_tables(short, _, p_table, a_table) when short == [], do: {p_table, a_table}
  defp r_gen_tables(_, long, p_table, a_table) when long == [], do: {p_table, a_table}

  defp r_gen_tables(short, long, p_table, a_table) do
    {short, j} = pop(short)
    [k | long_tl] = long
    a_table = Map.put(a_table, j, k)
    p_table = Map.update(p_table, k, 0, &(&1 - (1 - Map.fetch!(p_table, j))))

    if Map.fetch!(p_table, k) < 1 do
      r_gen_tables(append(short, k), long_tl, p_table, a_table)
    else
      r_gen_tables(short, long, p_table, a_table)
    end
  end

  defp indexes_by(lx, f),
    do: lx |> Enum.with_index() |> Enum.filter(fn {e, _} -> f.(e) end) |> Enum.map(&elem(&1, 1))

  defp pop(lx) do
    [head | tail] = lx |> Enum.reverse()
    {tail |> Enum.reverse(), head}
  end

  defp append(lx, e), do: [e | Enum.reverse(lx)] |> Enum.reverse()

  defp to_index_map(lx),
    do: lx |> Enum.with_index() |> Enum.map(fn {v, i} -> {i, v} end) |> Map.new()
end
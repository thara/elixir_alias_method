defmodule AliasMethodTest do
  use ExUnit.Case
  doctest AliasMethod

  describe "generate_table" do
    use ExUnit.Case

    ExUnit.Case.register_attribute(__ENV__, :params)

    for {weights, i} <-
          [
            [1.0, 1.0],
            [1.0, 1.0, 0.8],
            [0.5, 0.5],
            [0.2, 0.1, 0.4]
          ]
          |> Enum.with_index() do
      @params {weights}

      test "generate_table/#{i}", context do
        {weights} = context.registered.params

        table = AliasMethod.generate_table(weights)

        assert table.length == length(weights)
        assert map_size(table.probability_table) == length(weights)
        assert map_size(table.alias_table) == length(weights)
      end
    end
  end

  describe "choice" do
    use ExUnit.Case

    ExUnit.Case.register_attribute(__ENV__, :params)

    for {{weights, rates}, i} <-
          [
            {[10, 15], [40.0, 60.0]},
            {[20, 30], [40, 60]},
            {[20, 5], [80, 20]},
            {[25], [100]},
            {[1, 99], [1, 99]},
            {[1, 1, 8], [10, 10, 80]}
          ]
          |> Enum.with_index() do
      @params {weights, rates}

      test "choice/#{i}", context do
        {weights, rates} = context.registered.params

        table = AliasMethod.generate_table(weights)

        sample = 1_000_000

        result =
          0..sample
          |> Enum.reduce(%{}, fn _, result ->
            r = AliasMethod.choice(table)
            Map.update(result, r, 0, &(&1 + 1))
          end)

        for {rate, i} <- rates |> Enum.with_index() do
          count = result[i]

          p = rate / 100
          q = 1.0 - p
          expected = sample * p

          # 3.89 = inverse of normal distribution function with alpha=0.9999
          delta = 3.89 * :math.sqrt(sample * p * q)

          assert expected - delta <= count
          assert count <= expected + delta
        end
      end
    end
  end
end

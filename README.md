# AliasMethod

![Hex.pm](https://img.shields.io/hexpm/v/alias_method) [![Elixir CI](https://github.com/thara/elixir_alias_method/actions/workflows/elixir.yml/badge.svg)](https://github.com/thara/elixir_alias_method/actions/workflows/elixir.yml) 

Implementation of Walker's Alias method by Elixir.
The algorithm is principally useful when you need to random sampling with replacement by O(1).

## Installation

```elixir
def deps do
  [
    {:alias_method, "~> 0.1.0"}
  ]
end
```

## Example

```elixir
iex> weights = [1, 1, 8]
iex> table = AliasMethod.generate_table(weights)
iex> table
%AliasMethod.Table{alias_table: %{0 => 2, 1 => 2, 2 => 0}, length: 3, probability_table: %{0 => 0.3, 1 => 0.3, 2 => 1.0}}

iex> n = AliasMethod.choice(table)
iex> 0 <= n && n <= table.length
true
```


## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details

## Author

*Tomochika Hara* - [thara](https://github.com/thara)

defmodule AliasMethodTest do
  use ExUnit.Case
  doctest AliasMethod

  test "greets the world" do
    assert AliasMethod.hello() == :world
  end
end

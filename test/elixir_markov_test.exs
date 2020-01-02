defmodule ElixirMarkovTest do
  use ExUnit.Case
  doctest ElixirMarkov

  test "greets the world" do
    assert ElixirMarkov.hello() == :world
  end
end

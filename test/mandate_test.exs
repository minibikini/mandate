defmodule MandateTest do
  use ExUnit.Case
  doctest Mandate

  test "greets the world" do
    assert Mandate.hello() == :world
  end
end

defmodule Mandate.OptionParserExtendedTest do
  use ExUnit.Case, async: true
  
  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  describe "edge cases" do
    test "handles quoted string arguments with spaces" do
      root = [%Argument{name: :phrase, type: :string}]
      assert Mandate.OptionParser.parse(["hello world"], root) == {:ok, %{phrase: "hello world"}}
    end
  end
  
  describe "complex type combinations" do
    test "handles atom conversion failures gracefully" do
      root = [%Switch{name: :role, type: :atom}]
      assert_raise ArgumentError, fn ->
        Mandate.OptionParser.parse(["--role", "non:valid:atom"], root)
      end
    end
  end
end

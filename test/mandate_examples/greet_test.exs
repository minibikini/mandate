defmodule MandateExamples.GreetTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.MandateExamples.Greet

  test "parses required name argument" do
    assert {:ok, %{name: "John"}} =
             Mandate.OptionParser.parse(["John"], Mandate.Info.task(Greet))
  end

  test "handles verbose flag" do
    assert {:ok, %{name: "John", verbose: true}} =
             Mandate.OptionParser.parse(["John", "-v"], Mandate.Info.task(Greet))
  end

  test "requires name argument" do
    assert {:error, _} = Mandate.OptionParser.parse([], Mandate.Info.task(Greet))
  end
end

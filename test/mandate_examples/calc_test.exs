defmodule MandateExamples.CalcTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.MandateExamples.Calc

  test "parses expression argument" do
    assert {:ok, %{expression: "2 + 2"}} =
      Mandate.OptionParser.parse(["2 + 2"], Mandate.Info.root(Calc))
  end

  test "handles format and precision options" do
    assert {:ok, parsed} = Mandate.OptionParser.parse(
      ["2 * 3", "--format", "hex", "-p", "2"],
      Mandate.Info.root(Calc)
    )

    assert %{
      expression: "2 * 3",
      format: "hex",
      precision: 2
    } = parsed
  end

  test "requires expression argument" do
    assert {:error, _} = 
      Mandate.OptionParser.parse(["--format", "hex"], Mandate.Info.root(Calc))
  end
end

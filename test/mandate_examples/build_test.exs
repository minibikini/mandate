defmodule MandateExamples.BuildTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.MandateExamples.Build

  test "parses target and switches" do
    assert {:ok, parsed} = Mandate.OptionParser.parse(
      ["web", "-r", "--arch", "arm64", "-o", "-o"],
      Mandate.Info.root(Build)
    )

    assert %{
      target: "web",
      release: true,
      arch: "arm64",
      optimize: 2
    } = parsed
  end

  test "handles count type switch" do
    assert {:ok, %{optimize: 3}} =
      Mandate.OptionParser.parse(["web", "-o", "-o", "-o"], Mandate.Info.root(Build))
  end

  test "target is optional" do
    assert {:ok, _} = Mandate.OptionParser.parse([], Mandate.Info.root(Build))
  end
end

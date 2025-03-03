defmodule Mix.Tasks.Mandate.Gen.MixTaskTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Mandate.Gen.MixTask
  import ExUnit.CaptureIO

  @task_name "mandate.gen.mix_task"

  test "is a mix task" do
    assert Mix.Task.task?(MixTask)
    assert @task_name == Mix.Task.task_name(MixTask)
  end

  test "inject @shortdoc" do
    attributes = MixTask.__info__(:attributes)

    assert ["Generates a new Mix Task"] == Keyword.get(attributes, :shortdoc)
    assert "Generates a new Mix Task" == Mix.Task.shortdoc(MixTask)
  end

  test "inject @moduledoc" do
    attributes = MixTask.__info__(:attributes)

    assert [{1, text} | _] = Keyword.get(attributes, :moduledoc)
    assert text =~ "accepts arguments"
  end

  describe "mix task run" do
    setup do
      Mix.Task.reenable(@task_name)
    end

    test "Too many arguments" do
      output =
        capture_io(:stderr, fn ->
          Mix.Task.run(@task_name, ["one", "s", "sdds", "sds"])
        end)

      assert output =~ "Too many arguments. Expected maximum 2 but got 4."
    end

    test "Required arguments presence." do
      output =
        capture_io(:stderr, fn ->
          Mix.Task.run(@task_name, [])
        end)

      assert output =~ "Wrong number of required arguments. Expected 2 but got 0."
    end
  end
end

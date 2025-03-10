defmodule Mix.Tasks.Mandate.Gen.MixTaskTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Mandate.Gen.MixTask

  @task_name "mandate.gen.mix_task"

  test "is a mix task" do
    assert Mix.Task.task?(MixTask)
    assert @task_name == Mix.Task.task_name(MixTask)
  end

  test "inject @shortdoc" do
    attributes = MixTask.__info__(:attributes)

    str = "Generate a mix task"

    assert String.starts_with?(hd(Keyword.get(attributes, :shortdoc)), str)
    assert String.starts_with?(Mix.Task.shortdoc(MixTask), str)
  end

  test "inject @moduledoc" do
    attributes = MixTask.__info__(:attributes)

    assert [{1, text} | _] = Keyword.get(attributes, :moduledoc)
    assert text =~ "Genetares a mix task"
  end

  describe "mix task run" do
    setup do
      Mix.Task.reenable(@task_name)
    end

    test "Too many arguments" do
      assert_raise RuntimeError, "Too many arguments. Expected maximum 1 but got 4.", fn ->
        Mix.Task.run(@task_name, ["one", "s", "sdds", "sds"])
      end
    end

    test "Required arguments presence." do
      assert_raise RuntimeError,
                   "Wrong number of required arguments. Expected 1 but got 0.",
                   fn -> Mix.Task.run(@task_name, []) end
    end
  end
end

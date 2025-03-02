defmodule Mix.Tasks.Mandate.Gen.MixTaskTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Mandate.Gen.MixTask

  @task_name "mandate.gen.mix_task"

  test "inject @shortdoc" do
    attributes = MixTask.__info__(:attributes)

    assert ["Generates a new Mix Task"] = Keyword.get(attributes, :shortdoc)
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

    test "xxxx" do
      msg = "Too many arguments. Expected maximum 1 but got 4."

      assert_raise RuntimeError, msg, fn ->
        Mix.Task.run(@task_name, ["one", "s", "sdds", "sds"])
      end
    end

    test "Required arguments presence." do
      msg = "Wrong number of required arguments. Expected 1 but got 0."

      assert_raise RuntimeError, msg, fn ->
        Mix.Task.run(@task_name, [])
      end
    end
  end
end

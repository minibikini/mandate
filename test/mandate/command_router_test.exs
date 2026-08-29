defmodule Mandate.CommandRouterTest do
  use ExUnit.Case, async: true

  defmodule SubCommand do
    use Mandate.Command

    argument :name, :string do
      required true
    end

    switch :shout, :boolean do
      default false
    end

    run fn args ->
      greeting = "Hello, #{args.name}"
      if args[:shout], do: String.upcase(greeting), else: greeting
    end
  end

  defmodule AppRouter do
    use Mandate

    commands do
      command :sub, Mandate.CommandRouterTest.SubCommand

      command :inline do
        argument :target, :string

        run fn args ->
          "Inline target: #{args.target}"
        end
      end
    end
  end

  test "defines commands entity in router" do
    commands = Spark.Dsl.Extension.get_entities(AppRouter, [:commands])
    assert [_, _] = commands

    sub_cmd = Enum.find(commands, &(&1.name == :sub))
    assert match?({Mandate.CommandRouterTest.SubCommand, _opts}, sub_cmd.impl)

    inline_cmd = Enum.find(commands, &(&1.name == :inline))
    assert is_function(inline_cmd.run, 1)
  end

  test "main/1 can be called on router module" do
    result = AppRouter.main([])
    assert is_list(result)
    assert [_, _] = result
  end

  test "subcommand module has mod section entities" do
    entities = Spark.Dsl.Extension.get_entities(SubCommand, [:mod])
    arg = Enum.find(entities, &(&1.__struct__ == Mandate.Dsl.Argument))
    assert arg.name == :name
    assert arg.required == true

    switch = Enum.find(entities, &(&1.__struct__ == Mandate.Dsl.Switch))
    assert switch.name == :shout
    assert switch.type == :boolean
  end
end

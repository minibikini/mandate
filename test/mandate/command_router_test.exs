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

      command :multi_word do
        run fn _args ->
          "Multi word executed"
        end
      end
    end
  end

  defmodule DefaultRouter do
    use Mandate

    commands do
      default :greet

      command :greet do
        switch :loud, :boolean do
          default false
        end

        run fn args ->
          if args[:loud], do: "HI DEFAULT!", else: "hi default"
        end
      end

      command :other do
        run fn _args -> "other" end
      end
    end
  end

  test "defines commands entity in router" do
    commands = Spark.Dsl.Extension.get_entities(AppRouter, [:commands])
    assert [_, _, _] = commands

    sub_cmd = Enum.find(commands, &(&1.name == :sub))
    assert match?({Mandate.CommandRouterTest.SubCommand, _opts}, sub_cmd.impl)

    inline_cmd = Enum.find(commands, &(&1.name == :inline))
    assert is_function(inline_cmd.run, 1)
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

  test "dispatches to external subcommand module with args and switches" do
    assert AppRouter.main(["sub", "Alice"]) == "Hello, Alice"
    assert AppRouter.main(["sub", "Bob", "--shout"]) == "HELLO, BOB"
  end

  test "dispatches to inline command" do
    assert AppRouter.main(["inline", "production"]) == "Inline target: production"
  end

  test "dispatches using kebab-case command name" do
    assert AppRouter.main(["multi-word"]) == "Multi word executed"
    assert AppRouter.main(["multi_word"]) == "Multi word executed"
  end

  test "dispatches to default command when no command name provided or with flags" do
    assert DefaultRouter.main([]) == "hi default"
    assert DefaultRouter.main(["--loud"]) == "HI DEFAULT!"
    assert DefaultRouter.main(["other"]) == "other"
  end

  test "returns error on unknown command" do
    assert AppRouter.main(["nonexistent"]) == {:error, "Unknown command: nonexistent"}
  end

  test "returns error on missing required arguments" do
    assert {:error, msg} = AppRouter.main(["sub"])
    assert String.contains?(msg, "Wrong number of required arguments")
  end
end

defmodule Mandate.OptionParserTest do
  use ExUnit.Case, async: true

  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  describe "positional arguments" do
    test "parses valid positional arguments" do
      root = [
        %Argument{name: :num, type: :integer, required: true},
        %Argument{name: :text, type: :string}
      ]

      assert Mandate.OptionParser.parse(["100", "hello"], root) ==
               {:ok, %{num: 100, text: "hello"}}
    end

    test "returns error when missing required positional arguments" do
      root = [%Argument{name: :required_arg, type: :string, required: true}]

      assert Mandate.OptionParser.parse([], root) ==
               {:error, "Wrong number of required arguments. Expected 1 but got 0."}
    end

    test "returns error when too many positional arguments" do
      root = [%Argument{name: :a, type: :string}, %Argument{name: :b, type: :string}]

      assert Mandate.OptionParser.parse(["a", "b", "c"], root) ==
               {:error, "Too many arguments. Expected maximum 2 but got 3."}
    end

    test "parses required and optional positional args correctly" do
      root = [
        %Argument{name: :required, type: :string, required: true},
        %Argument{name: :optional, type: :string}
      ]

      assert Mandate.OptionParser.parse(["req"], root) == {:ok, %{required: "req"}}
    end

    test "parses float positional argument" do
      root = [%Argument{name: :price, type: :float, required: true}]
      assert Mandate.OptionParser.parse(["3.14"], root) == {:ok, %{price: 3.14}}
    end
  end

  describe "switches" do
    test "parses switches with correct types" do
      root = [%Switch{name: :level, type: :integer}]
      assert Mandate.OptionParser.parse(["--level", "3"], root) == {:ok, %{level: 3}}
    end

    test "applies default values to switches" do
      root = [%Switch{name: :port, type: :integer, default: 8080}]
      assert Mandate.OptionParser.parse([], root) == {:ok, %{port: 8080}}
    end

    test "returns error when required switch is missing" do
      root = [%Switch{name: :config, required: true, type: :string}]
      assert Mandate.OptionParser.parse([], root) == {:error, "Missing required switch: :config"}
    end

    test "parses switch with short alias" do
      root = [%Switch{name: :output, short: :o, type: :string}]
      assert Mandate.OptionParser.parse(["-o", "file.txt"], root) == {:ok, %{output: "file.txt"}}
    end

    test "includes optional switch as nil if not provided and no default" do
      root = [%Switch{name: :option, type: :string}]
      assert Mandate.OptionParser.parse([], root) == {:ok, %{option: nil}}
    end

    test "sets default value for switch" do
      root = [%Switch{name: :port, type: :integer, default: 8080}]
      assert Mandate.OptionParser.parse([], root) == {:ok, %{port: 8080}}
    end
  end

  describe "boolean switches" do
    test "defaults boolean switch to false" do
      root = [%Switch{name: :verbose, type: :boolean}]
      assert Mandate.OptionParser.parse([], root) == {:ok, %{verbose: false}}
    end

    test "sets default value for boolean switch" do
      root = [%Switch{name: :debug, type: :boolean, default: true}]
      assert Mandate.OptionParser.parse([], root) == {:ok, %{debug: true}}
    end
  end

  describe "multi-value switches" do
    test "accumulates values for switches with keep: true" do
      root = [%Switch{name: :file, type: :string, keep: true}]

      assert Mandate.OptionParser.parse(["--file", "a.txt", "--file", "b.txt"], root) ==
               {:ok, %{file: ["a.txt", "b.txt"]}}
    end

    test "keeps and wraps values for keep: true switches" do
      root = [%Switch{name: :tags, type: :atom, keep: true}]

      assert Mandate.OptionParser.parse(["--tags", "admin", "--tags", "user"], root) ==
               {:ok, %{tags: [:admin, :user]}}
    end

    test "parses keep switch with atom type" do
      root = [%Switch{name: :roles, type: :atom, keep: true}]

      assert Mandate.OptionParser.parse(["--roles", "admin", "--roles", "user"], root) ==
               {:ok, %{roles: [:admin, :user]}}
    end
  end

  describe "count switches" do
    test "parses count switch with short alias" do
      root = [%Switch{name: :verbose, type: :count, short: :v}]
      assert Mandate.OptionParser.parse(["-v", "-v", "-v"], root) == {:ok, %{verbose: 3}}
    end

    test "parses count switch with long form" do
      root = [%Switch{name: :verbose, type: :count}]
      assert Mandate.OptionParser.parse(["--verbose", "--verbose"], root) == {:ok, %{verbose: 2}}
    end
  end

  describe "type conversions" do
    test "converts switch value to atom" do
      root = [%Switch{name: :env, type: :atom}]
      assert Mandate.OptionParser.parse(["--env", "dev"], root) == {:ok, %{env: :dev}}
    end

    test "raises on non-existing atom for switch" do
      root = [%Switch{name: :env, type: :atom}]

      assert_raise ArgumentError, fn ->
        Mandate.OptionParser.parse(["--env", "non_existing_atom"], root)
      end
    end
  end

  describe "error handling" do
    test "returns error on invalid options" do
      root = []

      assert Mandate.OptionParser.parse(["--unknown", "-u"], root) ==
               {:error, "Invalid options: [\"--unknown\", \"-u\"]"}
    end
  end

  describe "mixed argument types" do
    test "parses mixed positional and switch arguments" do
      root = [
        %Argument{name: :id, type: :integer, required: true},
        %Switch{name: :debug, type: :boolean, short: :d}
      ]

      assert Mandate.OptionParser.parse(["123", "-d"], root) == {:ok, %{id: 123, debug: true}}
    end

    test "handles multiple switches with defaults and required" do
      root = [
        %Switch{name: :host, type: :string, required: true},
        %Switch{name: :port, type: :integer, default: 4000}
      ]

      assert Mandate.OptionParser.parse(["--host", "localhost"], root) ==
               {:ok, %{host: "localhost", port: 4000}}
    end
  end

  describe "edge cases" do
    test "handles empty list for keep: true switches when not provided" do
      root = [%Switch{name: :tags, type: :string, keep: true}]
      assert Mandate.OptionParser.parse([], root) == {:ok, %{tags: []}}
    end

    test "correctly merges positional args and switches" do
      root = [
        %Argument{name: :source, type: :string, required: true},
        %Switch{name: :source, type: :string, default: "override"}
      ]

      assert Mandate.OptionParser.parse(["input.txt"], root) == {:ok, %{source: "override"}}
    end

    test "handles atom positional arguments" do
      root = [%Argument{name: :env, type: :atom, required: true}]
      assert Mandate.OptionParser.parse(["prod"], root) == {:ok, %{env: :prod}}
    end

    test "prioritizes provided switch values over defaults" do
      root = [%Switch{name: :level, type: :integer, default: 1}]
      assert Mandate.OptionParser.parse(["--level", "5"], root) == {:ok, %{level: 5}}
    end

    test "handles boolean switches with no argument" do
      root = [%Switch{name: :verbose, type: :boolean}]
      assert Mandate.OptionParser.parse(["--verbose"], root) == {:ok, %{verbose: true}}
    end
  end
end

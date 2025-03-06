defmodule Mandate.OptionParserTest do
  use ExUnit.Case, async: true

  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  describe "positional arguments" do
    test "parses valid positional arguments" do
      command = [
        %Argument{name: :num, type: :integer, required: true},
        %Argument{name: :text, type: :string}
      ]

      assert Mandate.OptionParser.parse(["100", "hello"], command) ==
               {:ok, %{num: 100, text: "hello"}}
    end

    test "returns error when missing required positional arguments" do
      command = [%Argument{name: :required_arg, type: :string, required: true}]

      assert Mandate.OptionParser.parse([], command) ==
               {:error, "Wrong number of required arguments. Expected 1 but got 0."}
    end

    test "returns error when too many positional arguments" do
      command = [%Argument{name: :a, type: :string}, %Argument{name: :b, type: :string}]

      assert Mandate.OptionParser.parse(["a", "b", "c"], command) ==
               {:error, "Too many arguments. Expected maximum 2 but got 3."}
    end

    test "parses required and optional positional args correctly" do
      command = [
        %Argument{name: :required, type: :string, required: true},
        %Argument{name: :optional, type: :string}
      ]

      assert Mandate.OptionParser.parse(["req"], command) == {:ok, %{required: "req"}}
    end

    test "parses float positional argument" do
      command = [%Argument{name: :price, type: :float, required: true}]
      assert Mandate.OptionParser.parse(["3.14"], command) == {:ok, %{price: 3.14}}
    end
  end

  describe "switches" do
    test "parses switches with correct types" do
      command = [%Switch{name: :level, type: :integer}]
      assert Mandate.OptionParser.parse(["--level", "3"], command) == {:ok, %{level: 3}}
    end

    test "applies default values to switches" do
      command = [%Switch{name: :port, type: :integer, default: 8080}]
      assert Mandate.OptionParser.parse([], command) == {:ok, %{port: 8080}}
    end

    test "returns error when required switch is missing" do
      command = [%Switch{name: :config, required: true, type: :string}]

      assert Mandate.OptionParser.parse([], command) ==
               {:error, "Missing required switch: :config"}
    end

    test "parses switch with short alias" do
      command = [%Switch{name: :output, short: :o, type: :string}]

      assert Mandate.OptionParser.parse(["-o", "file.txt"], command) ==
               {:ok, %{output: "file.txt"}}
    end

    test "includes optional switch as nil if not provided and no default" do
      command = [%Switch{name: :option, type: :string}]
      assert Mandate.OptionParser.parse([], command) == {:ok, %{option: nil}}
    end

    test "sets default value for switch" do
      command = [%Switch{name: :port, type: :integer, default: 8080}]
      assert Mandate.OptionParser.parse([], command) == {:ok, %{port: 8080}}
    end
  end

  describe "boolean switches" do
    test "defaults boolean switch to false" do
      command = [%Switch{name: :verbose, type: :boolean}]
      assert Mandate.OptionParser.parse([], command) == {:ok, %{verbose: false}}
    end

    test "sets default value for boolean switch" do
      command = [%Switch{name: :debug, type: :boolean, default: true}]
      assert Mandate.OptionParser.parse([], command) == {:ok, %{debug: true}}
    end
  end

  describe "multi-value switches" do
    test "accumulates values for switches with keep: true" do
      command = [%Switch{name: :file, type: :string, keep: true}]

      assert Mandate.OptionParser.parse(["--file", "a.txt", "--file", "b.txt"], command) ==
               {:ok, %{file: ["a.txt", "b.txt"]}}
    end

    test "keeps and wraps values for keep: true switches" do
      command = [%Switch{name: :tags, type: :atom, keep: true}]

      assert Mandate.OptionParser.parse(["--tags", "admin", "--tags", "user"], command) ==
               {:ok, %{tags: [:admin, :user]}}
    end

    test "parses keep switch with atom type" do
      command = [%Switch{name: :roles, type: :atom, keep: true}]

      assert Mandate.OptionParser.parse(["--roles", "admin", "--roles", "user"], command) ==
               {:ok, %{roles: [:admin, :user]}}
    end
  end

  describe "count switches" do
    test "parses count switch with short alias" do
      command = [%Switch{name: :verbose, type: :count, short: :v}]
      assert Mandate.OptionParser.parse(["-v", "-v", "-v"], command) == {:ok, %{verbose: 3}}
    end

    test "parses count switch with long form" do
      command = [%Switch{name: :verbose, type: :count}]

      assert Mandate.OptionParser.parse(["--verbose", "--verbose"], command) ==
               {:ok, %{verbose: 2}}
    end
  end

  describe "type conversions" do
    test "converts switch value to atom" do
      command = [%Switch{name: :env, type: :atom}]
      assert Mandate.OptionParser.parse(["--env", "dev"], command) == {:ok, %{env: :dev}}
    end

    test "raises on non-existing atom for switch" do
      command = [%Switch{name: :env, type: :atom}]

      assert_raise ArgumentError, fn ->
        Mandate.OptionParser.parse(["--env", "non_existing_atom"], command)
      end
    end
  end

  describe "error handling" do
    test "returns error on invalid options" do
      command = []

      assert Mandate.OptionParser.parse(["--unknown", "-u"], command) ==
               {:error, "Invalid options: [\"--unknown\", \"-u\"]"}
    end
  end

  describe "mixed argument types" do
    test "parses mixed positional and switch arguments" do
      command = [
        %Argument{name: :id, type: :integer, required: true},
        %Switch{name: :debug, type: :boolean, short: :d}
      ]

      assert Mandate.OptionParser.parse(["123", "-d"], command) == {:ok, %{id: 123, debug: true}}
    end

    test "handles multiple switches with defaults and required" do
      command = [
        %Switch{name: :host, type: :string, required: true},
        %Switch{name: :port, type: :integer, default: 4000}
      ]

      assert Mandate.OptionParser.parse(["--host", "localhost"], command) ==
               {:ok, %{host: "localhost", port: 4000}}
    end
  end

  describe "edge cases" do
    test "handles empty list for keep: true switches when not provided" do
      command = [%Switch{name: :tags, type: :string, keep: true}]
      assert Mandate.OptionParser.parse([], command) == {:ok, %{tags: []}}
    end

    test "correctly merges positional args and switches" do
      command = [
        %Argument{name: :source, type: :string, required: true},
        %Switch{name: :source, type: :string, default: "override"}
      ]

      assert Mandate.OptionParser.parse(["input.txt"], command) == {:ok, %{source: "override"}}
    end

    test "handles atom positional arguments" do
      command = [%Argument{name: :env, type: :atom, required: true}]
      assert Mandate.OptionParser.parse(["prod"], command) == {:ok, %{env: :prod}}
    end

    test "prioritizes provided switch values over defaults" do
      command = [%Switch{name: :level, type: :integer, default: 1}]
      assert Mandate.OptionParser.parse(["--level", "5"], command) == {:ok, %{level: 5}}
    end

    test "handles boolean switches with no argument" do
      command = [%Switch{name: :verbose, type: :boolean}]
      assert Mandate.OptionParser.parse(["--verbose"], command) == {:ok, %{verbose: true}}
    end
  end
end

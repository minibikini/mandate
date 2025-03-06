defmodule Mandate.OptionParserTest do
  use ExUnit.Case

  alias Mandate.Dsl.Argument
  alias Mandate.Dsl.Switch

  test "parses valid positional arguments" do
    root = [
      %Argument{name: :num, type: :integer, required: true},
      %Argument{name: :text, type: :string}
    ]

    assert Mandate.OptionParser.parse(["100", "hello"], root) == {:ok, %{num: 100, text: "hello"}}
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

  test "accumulates values for switches with keep: true" do
    root = [%Switch{name: :file, type: :string, keep: true}]

    assert Mandate.OptionParser.parse(["--file", "a.txt", "--file", "b.txt"], root) ==
             {:ok, %{file: ["a.txt", "b.txt"]}}
  end

  test "returns error on invalid options" do
    root = []

    assert Mandate.OptionParser.parse(["--unknown", "-u"], root) ==
             {:error, "Invalid options: [\"--unknown\", \"-u\"]"}
  end

  test "defaults boolean switch to false" do
    root = [%Switch{name: :verbose, type: :boolean}]
    assert Mandate.OptionParser.parse([], root) == {:ok, %{verbose: false}}
  end

  test "converts switch value to atom" do
    root = [%Switch{name: :env, type: :atom}]
    assert Mandate.OptionParser.parse(["--env", "dev"], root) == {:ok, %{env: :dev}}
  end

  test "parses mixed positional and switch arguments" do
    root = [
      %Argument{name: :id, type: :integer, required: true},
      %Switch{name: :debug, type: :boolean, short: :d}
    ]

    assert Mandate.OptionParser.parse(["123", "-d"], root) == {:ok, %{id: 123, debug: true}}
  end

  test "parses switch with short alias" do
    root = [%Switch{name: :output, short: :o, type: :string}]
    assert Mandate.OptionParser.parse(["-o", "file.txt"], root) == {:ok, %{output: "file.txt"}}
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

  test "handles multiple switches with defaults and required" do
    root = [
      %Switch{name: :host, type: :string, required: true},
      %Switch{name: :port, type: :integer, default: 4000}
    ]

    assert Mandate.OptionParser.parse(["--host", "localhost"], root) ==
             {:ok, %{host: "localhost", port: 4000}}
  end

  test "keeps and wraps values for keep: true switches" do
    root = [%Switch{name: :tags, type: :atom, keep: true}]

    assert Mandate.OptionParser.parse(["--tags", "admin", "--tags", "user"], root) ==
             {:ok, %{tags: [:admin, :user]}}
  end
end

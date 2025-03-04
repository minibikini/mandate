defmodule Mix.Tasks.Mandate.Install.Docs do
  @moduledoc false

  def short_doc do
    "A short description of your task"
  end

  def example do
    "mix mandate.install --example arg"
  end

  def long_doc do
    """
    #{short_doc()}

    Longer explanation of your task

    ## Example

    ```bash
    #{example()}
    ```

    ## Options

    * `--example-option` or `-e` - Docs for your option
    """
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Mandate.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    # @impl Igniter.Mix.Task
    # def info(_argv, _composing_task) do
    #   %Igniter.Mix.Task.Info{
    #     # Groups allow for overlapping arguments for tasks by the same author
    #     # See the generators guide for more.
    #     group: :mandate,
    #     # *other* dependencies to add
    #     # i.e `{:foo, "~> 2.0"}`
    #     adds_deps: [],
    #     # *other* dependencies to add and call their associated installers, if they exist
    #     # i.e `{:foo, "~> 2.0"}`
    #     installs: [],
    #     # An example invocation
    #     example: __MODULE__.Docs.example(),
    #     # A list of environments that this should be installed in.
    #     only: nil,
    #     # a list of positional arguments, i.e `[:file]`
    #     positional: [],
    #     # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
    #     # This ensures your option schema includes options from nested tasks
    #     composes: [],
    #     # `OptionParser` schema
    #     schema: [],
    #     # Default values for the options in the `schema`
    #     defaults: [],
    #     # CLI aliases
    #     aliases: [],
    #     # A list of options in the schema that are required
    #     required: []
    #   }
    # end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      IO.inspect(igniter)
      # Do your work here and return an updated igniter
      igniter
      |> Igniter.add_warning("mix mandate.install is not yet implemented")
    end
  end
else
  defmodule Mix.Tasks.Mandate.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    def run(_argv) do
      Mix.shell().error("""
      The task 'mandate.install' requires igniter. Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end

defmodule Mix.Tasks.Mandate.Gen.IgniterTask do
  use Mandate, as: :igniter_task

  shortdoc "Generates a new igniter task"
  example "mix mandate.gen.igniter_task my_app.install --no-optional"

  argument :task_name do
    doc "Task name. Example: `my_app.my_task`"
    required true
  end

  switch :arg, :string do
    doc """
    Defines an argument for the generated task in the format: `name[:type][:required]`

    Can be called with `--argument` or `-a`.

    Format components:

    - `name`: Required. The argument name (e.g. `user_id`)
    - `type`: Optional. One of: `string` (default), `integer`, `float`, `string`
    - `required`: Optional. Specify 'required' to make the argument mandatory

    Examples:

      --arg filename         # String  (optional)
      -a age:integer         # Integer (optional)
      --arg role:atom        # Atom (optional)
      -a id:integer:required # Required integer
      --arg email:required   # Required string
    """

    short :a
    keep true
  end

  switch :switch, :string do
    doc """
    Defines a switch for the generated task in the format: name[:type][:short][:required]

    Can be called with `--switch` or `-s`.

    Format components (in order):

    - `name`: Required. The switch name (e.g. `color`)
    - `type`: Optional. One of: `boolean` (default), `string`, `integer`, `float`, `atom` (existing), `count`
    - `short`: Optional. Single letter alias (e.g. `h` for `-h`)
    - `required`: Optional. Add `required` to make the switch mandatory

    Examples:

      --switch debug                    # Boolean switch (optional)
      --switch help:boolean:h           # Boolean switch with -h alias
      -s color:string:c                # String switch with -c alias
      --switch age:integer:a:required   # Required integer switch with -a alias
      -s count:count:n                 # Counter switch with -n alias
      --switch port:float:p:required    # Required float switch with -p alias
    """

    short :s
    keep true
  end

  switch :optional do
    default true

    doc "Whether or not to define the task to be compatible with igniter as an optional dependency."
  end

  switch :upgrade do
    short :u
    doc "Whether or not the task is an upgrade task. See the upgrades guide for more."
  end

  switch :private do
    short :p
    doc "Whether or not the task is a private task. This means it has no shortdoc or moduledoc."
  end

  run fn igniter, options ->
    task_name = options[:task_name]

    options =
      if options[:upgrade] do
        Keyword.put(options, :private, true)
      else
        options
      end

    module_name = Module.concat(Mix.Tasks, Mix.Utils.command_to_module_name(to_string(task_name)))

    app_name = Igniter.Project.Application.app_name(igniter)

    contents =
      if options[:optional] do
        optional_template(module_name, task_name, app_name, options)
      else
        template(module_name, task_name, app_name, options)
      end

    file = "lib/mix/tasks/#{task_name}.ex"

    if Igniter.exists?(igniter, file) do
      Igniter.add_issue(
        igniter,
        "Could not generate task #{task_name}, as `#{file}` already exists."
      )
    else
      Igniter.create_new_file(igniter, file, contents)
    end
  end

  defp template(module_name, task_name, app_name, opts) do
    docs =
      if opts[:private] do
        "@moduledoc false"
      else
        """
        shortdoc "A short description of your task"
        longdoc \"\"\"
        Longer explanation of your task
        \"\"\"
        """
      end

    """
    defmodule #{inspect(module_name)} do
      use Mandate, as: :igniter_task

      example "mix #{task_name} --example arg"

      #{docs}

      @impl Igniter.Mix.Task
      def info(_argv, _composing_task) do
        %Igniter.Mix.Task.Info{
          # Groups allow for overlapping arguments for tasks by the same author
          # See the generators guide for more.
          group: #{inspect(app_name)},
          # *other* dependencies to add
          # i.e `{:foo, "~> 2.0"}`
          adds_deps: [],
          # *other* dependencies to add and call their associated installers, if they exist
          # i.e `{:foo, "~> 2.0"}`
          installs: [],
          # An example invocation
          example: @example,
          #{only(opts, task_name)}\
          # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
          # This ensures your option schema includes options from nested tasks
          composes: [],
        }
      end

      run fn igniter, options ->
        #{execute(opts, task_name)}
      end
    end
    """
  end

  defp optional_template(module_name, task_name, app_name, opts) do
    """
    if Code.ensure_loaded?(Igniter) do
      defmodule #{inspect(module_name)} do
        use Mandate, as: :igniter_task

        @impl Igniter.Mix.Task
        def info(_argv, _composing_task) do
          %Igniter.Mix.Task.Info{
            # Groups allow for overlapping arguments for tasks by the same author
            # See the generators guide for more.
            group: #{inspect(app_name)},
            # *other* dependencies to add
            # i.e `{:foo, "~> 2.0"}`
            adds_deps: [],
            # *other* dependencies to add and call their associated installers, if they exist
            # i.e `{:foo, "~> 2.0"}`
            installs: [],
            #{only(opts, task_name)}\
            # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
            # This ensures your option schema includes options from nested tasks
            composes: []
          }
        end

        run fn igniter, options ->
          #{execute(opts, task_name)}
        end
      end
    else
      defmodule #{inspect(module_name)} do
        use Mix.Task

        def run(_argv) do
          Mix.shell().error(\"\"\"
          The task '#{task_name}' requires igniter. Please install igniter and try again.

          For more information, see: https://hexdocs.pm/igniter/readme.html#installation
          \"\"\")

          exit({:shutdown, 1})
        end
      end
    end
    """
  end

  defp only(opts, task_name) do
    if !opts[:upgrade] && String.ends_with?(task_name, ".install") do
      """
      # A list of environments that this should be installed in.
      only: nil,
      """
    else
      ""
    end
  end

  defp execute(opts, task_name) do
    if opts[:upgrade] do
      """
      upgrades = %{
        # "0.1.1" => [&change_foo_to_bar/2]
      }
      # For each version that requires a change, add it to this map
      # Each key is a version that points at a list of functions that take an
      # igniter and options (i.e. flags or other custom options).
      # See the upgrades guide for more.
      Igniter.Upgrades.run(igniter, options.from, options.to, upgrades, custom_opts: options)
      """
    else
      """
      # Do your work here and return an updated igniter
      igniter
      |> Igniter.add_warning("mix #{task_name} is not yet implemented")
      """
    end
  end
end

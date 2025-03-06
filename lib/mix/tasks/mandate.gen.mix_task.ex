defmodule Mix.Tasks.Mandate.Gen.MixTask do
  use Mandate.Task, as: :igniter

  example "mix mandate.gen.mix_task my_app.my_task --example arg"

  longdoc "Generate a mix task for your application"
  shortdoc "Generate a mix task for your application"

  longdoc """
  Genetares a mix task for your application
  """

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

  run fn igniter ->
    positional = igniter.args.positional
    options = igniter.args.options

    task_name = positional[:task_name]

    module_name = module_name(task_name)
    app_name = Igniter.Project.Application.app_name(igniter)
    file = "lib/mix/tasks/#{task_name}.ex"
    contents = template(module_name, task_name, app_name, options)

    if Igniter.exists?(igniter, file) do
      Igniter.add_issue(
        igniter,
        "Could not generate task #{task_name}, as `#{file}` already exists."
      )
    else
      Igniter.create_new_file(igniter, file, contents)
    end
  end

  defp module_name(task_name) do
    Module.concat(Mix.Tasks, Mix.Utils.command_to_module_name(to_string(task_name)))
  end

  defp render_argument(arg) do
    [name | parts] = String.split(arg, ":")

    type =
      case Enum.find(parts, &(&1 in ~w(string integer float atom))) do
        nil -> :string
        "string" -> :string
        "integer" -> :integer
        "float" -> :float
        "atom" -> :atom
      end

    Enum.join(
      ["argument :#{name}"] ++
        if(type != :string, do: [", :#{type}"], else: []) ++
        if("required" in parts, do: [" do\n  required true\nend"], else: [])
    )
  end

  defp render_switch(switch) do
    [name | parts] = String.split(switch, ":")

    type =
      case Enum.find(parts, &(&1 in ~w(boolean string integer float atom count))) do
        nil -> :boolean
        "boolean" -> :boolean
        "string" -> :string
        "integer" -> :integer
        "float" -> :float
        "atom" -> :atom
        "count" -> :count
      end

    # Parse short (single letter alias)
    short = Enum.find(parts, fn part -> String.length(part) == 1 and part =~ ~r/^[a-zA-Z]$/ end)

    str = "switch :#{name}" <> if(type != :boolean, do: ", :#{type}", else: "")

    if is_binary(short) or "required" in parts do
      """
      #{str} do
        #{if("required" in parts, do: "required true")}
        #{if(short, do: "short :#{short}")}
      end
      """
    else
      str
    end
  end

  defp template(module_name, task_name, _app_name, options) do
    [
      """
        defmodule #{inspect(module_name)} do
        use Mandate.Task

          # shortdoc "Generates a new Mix Task"
          # longdoc "Generates a new Mix Task, accepts arguments"
          # example "mix #{task_name} new --num 13.37 --pin 42 -p 13"
      """,
      Enum.map(options[:arg], &render_argument/1),
      Enum.map(options[:switch], &render_switch/1),
      """

        run fn args ->
          Mix.shell().info("Running `#{task_name}` with: \#{inspect(args)}")
        end
      end
      """
    ]
    |> List.flatten()
    |> Enum.join("\n")
  end
end

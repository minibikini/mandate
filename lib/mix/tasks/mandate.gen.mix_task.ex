defmodule Mix.Tasks.Mandate.Gen.MixTask do
  use Mandate, as: :igniter_task

  example "mix mandate.gen.mix_task my_app.my_task --example arg"

  shortdoc "Generate a mix task for your application"

  longdoc """
  Genetares a mix task for your application
  """

  argument :task_name do
    doc "Task name. Example: `my_app.my_task`"
    required true
  end

  run fn igniter, options ->
    task_name = options[:task_name]

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

  defp template(module_name, task_name, _app_name, _options) do
    """
    defmodule #{inspect(module_name)} do
      use Mandate, as: :mix_task

      shortdoc "Generates a new Mix Task"
      longdoc "Generates a new Mix Task, accepts arguments"
      example "mix #{task_name} new --num 13.37 --pin 42 -p 13"

      argument :action_name do
        required true
      end

      switch :color, :string do
        default "#000000"
      end

      switch :num, :float do
        doc "Any number"
        example 3.14
      end

      switch :help, short: :h

      switch :pin, :integer do
        short :p
        keep true
      end

      run fn args, _ ->
        Mix.shell().info("Running `#{task_name}` with: \#{inspect(args)}")
      end
    end
    """
  end
end

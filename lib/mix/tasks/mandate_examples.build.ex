defmodule Mix.Tasks.MandateExamples.Build do
  use Mandate, as: :igniter_task

  argument :target do
    required false
  end

  switch :release, :boolean do
    short :r
  end

  switch :arch, :string do
    short :a
  end

  switch :optimize, :count do
    short :o
  end

  @impl Igniter.Mix.Task
  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      group: :mandate,
      adds_deps: [],
      installs: [],
      composes: []
    }
  end

  run fn igniter, options ->
    igniter
    |> Igniter.add_warning("mix mandate_examples.build is not yet implemented")
  end
end

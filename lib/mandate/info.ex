defmodule Mandate.Info do
  @moduledoc false
  use Spark.InfoGenerator, extension: Mandate.TaskDsl, sections: [:task]
end

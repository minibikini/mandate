defmodule Mandate.Info do
  use Spark.InfoGenerator, extension: Mandate.TaskDsl, sections: [:task]
end

defmodule Mandate.Info do
  use Spark.InfoGenerator, extension: Mandate.Dsl, sections: [:root]
end

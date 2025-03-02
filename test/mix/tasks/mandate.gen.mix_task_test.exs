defmodule Mix.Tasks.Mandate.Gen.MixTaskTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Mandate.Gen.MixTask

  test "inject @shortdoc" do
    attributes = MixTask.__info__(:attributes)

    assert ["Generates a new Mix Task"] = Keyword.get(attributes, :shortdoc)
  end

  # test "inject @moduledoc" do
  #   attributes = MixTask.__info__(:attributes)

  #   assert ["Generates a new Mix Task"] = Keyword.get(attributes, :moduledoc)
  # end

  # test "mandate.gen.mix_task" do
  #   args = []

  #   Mix.Task.run("mandate.gen.mix_task", args)
  # end

  # describe "run/1" do
  #   setup context do
  #     Gen.run(context[:argv])

  #     Mix.Task.run("mandate.gen.mix_task", context[:argv])

  #     assert_received {:mix_shell, :info, [jwt]}

  #     # token = Cerebro.Jwt.verify_jwt(jwt)

  #     {:ok, claims: token.claims, token: token}
  #     {:ok, claims: token.claims, token: token}
  #   end

  #   @tag argv: []
  #   test "prints a valid JWT with no args", %{token: token} do
  #     jwt
  #     refute token.error
  #   end

  # @tag argv: ["--exp", "123"]
  # test "prints a valid JWT when passed an expiration", %{claims: claims} do
  #   assert_in_delta claims["exp"], Joken.current_time(), 124
  # end

  # @tag argv: ["--jti", "fdsa"]
  # test "prints a valid JWT when passed a jti", %{claims: claims} do
  #   assert claims["jti"] == "fdsa"
  # end

  # @tag argv: ["--iss", "logan"]
  # test "prints a valid JWT when passed an iss", %{claims: claims} do
  #   assert claims["iss"] == "logan"
  # end

  # @tag argv: ["--token", "asdf"]
  # test "prints a valid JWT when passed a token", %{claims: claims} do
  #   assert claims["token"] == "asdf"
  # end
  # end
end

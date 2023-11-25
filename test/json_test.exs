defmodule JSONTest do
  use ExUnit.Case

  "JSONTestSuite/test_parsing/*"
  |> Path.wildcard()
  |> Enum.map(fn file ->
    name = Path.basename(file)

    case name do
      "y_" <> _ ->
        test name do
          {:ok, json} = File.read(unquote(file))
          assert {:ok, _} = JSON.parse(json)
        end

      "n_" <> _ ->
        test name do
          {:ok, json} = File.read(unquote(file))
          assert [:error | _] = JSON.parse(json) |> Tuple.to_list()
        end

      _ ->
        []
    end
  end)
end

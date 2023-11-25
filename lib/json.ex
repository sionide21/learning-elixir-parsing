defmodule JSON do
  def ast(input) when is_list(input) do
    with {:ok, tokens, _} <- :json_lexer.string(input) do
      :json_parser.parse(tokens)
    end
  end

  def ast(input) when is_binary(input) do
    input
    |> :erlang.binary_to_list()
    |> ast()
  end

  def parse(input) do
    with {:ok, json} <- ast(input) do
      {:ok, create_map(json)}
    end
  end

  def create_map(ast) do
    case ast do
      {:object, items} -> Map.new(items, fn {k, v} -> {handle_string(k), create_map(v)} end)
      items when is_list(items) -> Enum.map(items, &create_map/1)
      {:number, value} -> handle_number(value)
      {:string, value} -> handle_string(value)
      value -> value
    end
  end

  def handle_number(number) do
    number = :erlang.list_to_binary(number)

    if String.match?(number, ~r/^\d+$/) do
      String.to_integer(number)
    else
      number
      |> Float.parse()
      |> then(fn {value, ""} -> value end)
    end
  end

  def handle_string([?" | string]) do
    string
    |> Enum.drop(-1)
    |> :erlang.list_to_binary()
    |> String.replace(~r/\\u[0-9A-Fa-f]/, fn "\\u" <> hexcode ->
      hexcode
      |> String.to_integer(16)
      |> then(&<<&1>>)
    end)
    |> String.replace(~r/\\(.)/, fn "\\" <> chr ->
      case chr do
        "\"" -> "\""
        "\\" -> "\\"
        "b" -> "\b"
        "f" -> "\f"
        "n" -> "\n"
        "r" -> "\r"
        "t" -> "\t"
        v -> v
      end
    end)
  end
end

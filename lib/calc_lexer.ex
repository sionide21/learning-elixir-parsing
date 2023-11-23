defmodule CalcLexer do
  @literals ~w{ + - * / ^ ( ) }
  @whitespace [?\s, ?\t, ?\n, ?\r]

  def string(input) when is_binary(input) do
    string(input, %{line: 1, tokens: []})
  end

  def string(input) when is_list(input) do
    input
    |> :erlang.list_to_binary()
    |> string()
  end

  def string(<<literal::binary-size(1)>> <> rest, ctx) when literal in @literals do
    add_token(ctx, String.to_atom(literal), rest)
  end

  def string("\n" <> rest, ctx) do
    string(rest, update_in(ctx[:line], &(&1 + 1)))
  end

  def string(<<ws>> <> rest, ctx) when ws in @whitespace do
    string(rest, ctx)
  end

  def string(<<digit>> <> _ = input, ctx) when digit in ?0..?9 do
    case Regex.run(~r/^[0-9]+(\.[0-9]+)?/, input) do
      [integer] -> number(:int, integer, input, ctx)
      [float, _] -> number(:float, float, input, ctx)
    end
  end

  def string(<<delim>> <> rest, ctx) when delim in [?", ?}] do
    {length, end_delim} = match_string(rest, 0)
    delim_length = byte_size(end_delim)
    <<value::binary-size(length), _::binary-size(delim_length)>> <> rest = rest
    value = String.replace(value, ~r/\\(.)/, "\\g{1}")

    token =
      case {delim, end_delim} do
        {?", "\""} -> :string_literal
        {?", "\#{"} -> :string_start
        {?}, "\#{"} -> :string_middle
        {?}, "\""} -> :string_end
      end

    add_token(ctx, token, value, rest)
  end

  def string("", ctx) do
    {:ok, Enum.reverse(ctx[:tokens]), ctx[:line]}
  end

  def add_token(ctx, type, rest) do
    add_and_advance(ctx, {type, ctx[:line]}, rest)
  end

  def add_token(ctx, type, value, rest) do
    add_and_advance(ctx, {type, ctx[:line], value}, rest)
  end

  def add_and_advance(ctx, token, rest) do
    string(rest, update_in(ctx[:tokens], &[token | &1]))
  end

  def number(type, match, input, ctx) do
    value =
      case type do
        :int -> String.to_integer(match)
        :float -> String.to_float(match)
      end

    <<_::binary-size(byte_size(match))>> <> rest = input

    add_token(ctx, type, value, rest)
  end

  def match_string(string, length) do
    case string do
      <<"\\", _>> <> rest -> match_string(rest, length + 2)
      <<"\\\#{">> <> rest -> match_string(rest, length + 3)
      "\"" <> _ -> {length, "\""}
      "\#{" <> _ -> {length, "\#{"}
      <<_>> <> rest -> match_string(rest, length + 1)
      "" -> :error
    end
  end
end

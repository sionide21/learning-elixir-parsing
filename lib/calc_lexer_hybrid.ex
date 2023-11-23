defmodule CalcLexerHybrid do
  def string(input) do
    do_string(input, [], 1)
  end

  def do_string([delim | rest], tokens, loc) when delim in [?", ?}] do
    with {length, delim_length, end_delim} <- match_string(rest, 0) do
      {string, rest} = Enum.split(rest, length)
      rest = Enum.drop(rest, delim_length)

      value =
        string
        |> :erlang.list_to_binary()
        |> String.replace(~r/\\(.)/, "\\g{1}")

      token =
        case {delim, end_delim} do
          {?", '"'} -> :string_literal
          {?", '\#{'} -> :string_start
          {?}, '\#{'} -> :string_middle
          {?}, '"'} -> :string_end
        end

      do_string(rest, [{token, loc, value} | tokens], loc)
    end
  end

  def do_string(input, tokens, loc) do
    case next_token([], input, loc) do
      {{:ok, token, loc}, rest} -> do_string(rest, [token | tokens], loc)
      {{:eof, loc}, _} -> {:ok, Enum.reverse(tokens), loc}
      {err, _} -> err
    end
  end

  def match_string(string, length) do
    case string do
      [?\\, ?#, ?{ | rest] -> match_string(rest, length + 3)
      [?\\, _ | rest] -> match_string(rest, length + 2)
      [?" | _] -> {length, 1, '"'}
      [?#, ?{ | _] -> {length, 2, '\#{'}
      [_ | rest] -> match_string(rest, length + 1)
      [] -> {:error, 'unterminated string'}
    end
  end

  def next_token(cont, input, loc) do
    cont
    |> :calc_lexer.token(input, loc)
    |> case do
      {:done, token, rest} -> {token, rest}
      {:more, cont} -> next_token(cont, :eof, loc)
    end
  end
end

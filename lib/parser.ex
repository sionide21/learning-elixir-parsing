defmodule Parser do
  def shell() do
    IO.gets("> ")
    |> case do
      "\n" ->
        :ok

      expr ->
        expr
        |> Parser.calc()
        |> case do
          {:ok, ast} -> IO.inspect(ast)
          err -> IO.inspect(err)
        end

        shell()
    end
  end

  def parse(input) when is_list(input) do
    with {:ok, tokens, _} <- :list_lexer.string(input) do
      :list_parser.parse(tokens)
    end
  end

  def parse(input) when is_binary(input) do
    input
    |> :erlang.binary_to_list()
    |> parse()
  end

  def calc(input) when is_list(input) do
    with {:ok, tokens, _} <- CalcLexerHybrid.string(input) do
      :calc_parser.parse(tokens)
    end
  end

  def calc(input) when is_binary(input) do
    input
    |> :erlang.binary_to_list()
    |> calc()
  end

  defmacro sigil_l({:<<>>, _, [list]}, _) do
    {:ok, ast} = parse(list)
    ast
  end
end

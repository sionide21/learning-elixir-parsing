Definitions.

DIGIT = [0-9]
WHITESPACE = [\s\t\n\r]

Rules.

{DIGIT}+ : {token, {int, TokenLine, list_to_integer(TokenChars)}}.

{DIGIT}+\.{DIGIT}+ : {token, {float, TokenLine, list_to_float(TokenChars)}}.

["}]([^\\\"{]|\\\"|\\{)*["{] : {token, handle_string(TokenLine, TokenChars)}.

\+ : {token, {'+', TokenLine}}.
\- : {token, {'-', TokenLine}}.
\* : {token, {'*', TokenLine}}.
\/ : {token, {'/', TokenLine}}.
\^ : {token, {'^', TokenLine}}.
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.

{WHITESPACE}+ : skip_token.


Erlang code.

handle_string(TokenLine, Str) ->
  {Open, Str0} = lists:split(1, Str),
  {Str1, Close} = lists:split(length(Str0) - 1, Str0),
  Value = list_to_binary(
    string:replace(Str1, "\\\"", "\"", all)
  ),
  Token = case {Open, Close} of
    {"\"", "\""} -> string_literal;
    {"\"", "{"} -> string_start;
    {"}", "{"} -> string_middle;
    {"}", "\""} -> string_end
  end,
  {Token, TokenLine, Value}.

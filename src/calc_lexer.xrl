Definitions.

DIGIT = [0-9]
WHITESPACE = [\s\t\n\r]

Rules.

{DIGIT}+ : {token, {int, TokenLine, list_to_integer(TokenChars)}}.

{DIGIT}+\.{DIGIT}+ : {token, {float, TokenLine, list_to_float(TokenChars)}}.

"([^\\\"]|\\\")*" : {token, {string, TokenLine, string_literal(TokenChars)}}.

\+ : {token, {'+', TokenLine}}.
\- : {token, {'-', TokenLine}}.
\* : {token, {'*', TokenLine}}.
\/ : {token, {'/', TokenLine}}.
\^ : {token, {'^', TokenLine}}.
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.

{WHITESPACE}+ : skip_token.


Erlang code.

string_literal(Str) ->
  {Str0, _} = lists:split(length(Str) - 1, Str),
  {_, Str1} = lists:split(1, Str0),
  list_to_binary(
    string:replace(Str1, "\\\"", "\"", all)
  ).

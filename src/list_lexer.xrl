Definitions.

WHITESPACE = [\s\t\n\r]

Rules.

[0-9]+ : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
:[a-z_]+ : {token, {atom, TokenLine, to_atom(TokenChars)}}.
\[ : {token, {'[', TokenLine}}.
\] : {token, {']', TokenLine}}.
,  : {token, {',', TokenLine}}.

{WHITESPACE}+ : skip_token.


Erlang code.

to_atom([$: | Atom]) ->
  list_to_atom(Atom).

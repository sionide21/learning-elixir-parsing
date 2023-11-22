Definitions.

DIGIT = [0-9]
WHITESPACE = [\s\t\n\r]

Rules.

{DIGIT}+ : {token, {int, TokenLine, list_to_integer(TokenChars)}}.

{DIGIT}+\.{DIGIT}+ : {token, {float, TokenLine, list_to_float(TokenChars)}}.

\+ : {token, {'+', TokenLine}}.
\- : {token, {'-', TokenLine}}.
\* : {token, {'*', TokenLine}}.
\/ : {token, {'/', TokenLine}}.
\^ : {token, {'^', TokenLine}}.
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.

{WHITESPACE}+ : skip_token.


Erlang code.

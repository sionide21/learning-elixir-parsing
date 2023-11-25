Definitions.

MINUS = \-
PLUS = \+
DIGIT19 = [1-9]
DIGIT = [0-9]
DECIMAL = \.
E = [eE]

WHITESPACE = [\s\t\n\r]

Rules.

{MINUS}?{DIGIT19}{DIGIT}*({DECIMAL}{DIGIT}+)?({E}({PLUS}|{MINUS})?{DIGIT}+)? : {token, {number, TokenLine, TokenChars}}.
0 : {token, {number, TokenLine, "0"}}.

"([^\"\\]|\\.)*" : {token, {string, TokenLine, TokenChars}}.

\{ : {token, {'{', TokenLine}}.
\} : {token, {'}', TokenLine}}.
\[ : {token, {'[', TokenLine}}.
\] : {token, {']', TokenLine}}.
\: : {token, {':', TokenLine}}.
\, : {token, {',', TokenLine}}.

false : {token, {false, TokenLine}}.
null : {token, {nil, TokenLine}}.
true : {token, {true, TokenLine}}.


{WHITESPACE}+ : skip_token.


Erlang code.

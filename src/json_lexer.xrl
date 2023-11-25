Definitions.

MINUS = \-
PLUS = \+
DIGIT19 = [1-9]
DIGIT = [0-9]
DECIMAL = \.
E = [eE]

HEX = [0-9A-Fa-f]

WHITESPACE = [\s\t\n\r]

Rules.

{MINUS}?(0|{DIGIT19}{DIGIT}*)({DECIMAL}{DIGIT}+)?({E}({PLUS}|{MINUS})?{DIGIT}+)? : {token, {number, TokenLine, TokenChars}}.

"([^\"\\\x00-\x1F]|\\[^u\x00-\x1F]|\\u{HEX}{HEX}{HEX}{HEX})*" : {token, {string, TokenLine, TokenChars}}.

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

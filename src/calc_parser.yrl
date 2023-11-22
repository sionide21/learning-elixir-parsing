Terminals '+' '-' '*' '/' '^' '(' ')' int float string.

Nonterminals eqn val num.

Rootsymbol eqn.

Left 100 '+' '-'.
Left 200 '*' '/'.
Left 300 '^'.

eqn -> val : '$1'.
eqn -> eqn '+' eqn : {'+', '$1', '$3'}.
eqn -> eqn '-' eqn : {'-', '$1', '$3'}.
eqn -> eqn '*' eqn : {'*', '$1', '$3'}.
eqn -> eqn '/' eqn : {'/', '$1', '$3'}.
eqn -> eqn '^' eqn : {'^', '$1', '$3'}.

eqn -> val '(' eqn ')' : {'*', '$1', '$3'}.

val -> '(' eqn ')' : '$2'.
val -> num : '$1'.
val -> '-' num : negate_num('$2').

num -> int : extract_token('$1').
num -> float : extract_token('$1').
num -> string : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.

negate_num(Value) -> -1 * Value.

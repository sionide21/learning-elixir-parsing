Terminals '+' '-' '*' '/' '^' '(' ')' int float string_literal string_start string_end string_middle.

Nonterminals eqn val num string string_rest.

Rootsymbol eqn.

Left 100 '+' '-'.
Left 200 '*' '/'.
Left 300 '^'.

eqn -> val : '$1'.
eqn -> string : '$1'.
eqn -> eqn '+' eqn : {'+', '$1', '$3'}.
eqn -> eqn '-' eqn : {'-', '$1', '$3'}.
eqn -> eqn '*' eqn : {'*', '$1', '$3'}.
eqn -> eqn '/' eqn : {'/', '$1', '$3'}.
eqn -> eqn '^' eqn : {'^', '$1', '$3'}.

eqn -> val '(' eqn ')' : {'*', '$1', '$3'}.

val -> '(' eqn ')' : '$2'.
val -> num : '$1'.
val -> '-' num : negate_num('$2').

string -> string_literal : extract_token('$1').
string -> string_start eqn string_rest : {'{}', [extract_token('$1'), '$2' | '$3']}.

string_rest -> string_end : [extract_token('$1')].
string_rest -> string_middle eqn string_rest : [extract_token('$1'), '$2' | '$3'].

num -> int : extract_token('$1').
num -> float : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.

negate_num(Value) -> -1 * Value.

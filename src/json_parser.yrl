Terminals number string true false nil '{' '}' '[' ']' ':' ','.

Nonterminals object object_elems object_elem array array_elems value.

Rootsymbol value.

value -> number : {number, extract_token('$1')}.
value -> string : {string, extract_token('$1')}.
value -> true : extract_token('$1').
value -> false : extract_token('$1').
value -> nil : extract_token('$1').
value -> object : {object, '$1'}.
value -> array : '$1'.

% Objects
object -> '{' '}' : [].
object -> '{' object_elems '}' : '$2'.

object_elems -> object_elem : ['$1'].
object_elems -> object_elem ',' object_elems : ['$1' | '$3'].

object_elem -> string ':' value : {extract_token('$1'), '$3'}.

% Arrays
array -> '[' ']' : [].
array -> '[' array_elems ']' : '$2'.

array_elems -> value : ['$1'].
array_elems -> value ',' array_elems : ['$1' | '$3'].

Erlang code.

extract_token({_Token, _Line, Value}) -> Value;
extract_token({Value, _Line}) -> Value.

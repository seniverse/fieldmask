Definitions.

Name = [a-zA-Z][0-9a-zA-Z_]*
Sym  = [()/*,]

Rules.

{Name} : {token, {name, TokenLine, TokenChars}}.
{Sym}  : {token, {list_to_atom(TokenChars), TokenLine}}.

Erlang code.


Nonterminals field mask masks wildcard fieldmask.
Terminals name '(' ')' '/' ',' '*'.
Rootsymbol fieldmask.

fieldmask -> wildcard:
  '$1'.

fieldmask -> masks:
  '$1'.

wildcard -> '*':
  '*'.

wildcard -> '*' '/' wildcard:
  {'*', '$3'}.

wildcard -> '*' '/' mask:
  {'*', ['$3']}.

wildcard -> '*' '(' masks ')':
  {'*', '$3'}.

masks -> mask:
  ['$1'].

masks -> mask ',' masks:
  ['$1'|'$3'].

mask -> field:
  '$1'.

mask -> field '/' wildcard:
  {'$1', '$3'}.

mask -> field '/' mask:
  {'$1', ['$3']}.

mask -> field '(' masks ')':
  {'$1', '$3'}.


field -> name:
  field('$1').

Erlang code.

field({name, _, Name}) ->
    list_to_binary(Name).

%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.

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

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

Definitions.

Name = [a-zA-Z][0-9a-zA-Z_]*
Sym  = [()/*,]

Rules.

{Name} : {token, {name, TokenLine, TokenChars}}.
{Sym}  : {token, {list_to_atom(TokenChars), TokenLine}}.

Erlang code.

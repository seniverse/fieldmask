-module(fieldmask).

-export([parse/1, mask/2]).

parse(S) ->
    case fieldmask_lexer:string(S) of
        {ok, Tokens, _} ->
            fieldmask_parser:parse(Tokens);
        {error, Error, _} ->
            {error, Error}
    end.

mask(Mask, Value) when is_list(Value) ->
    [mask(Mask, E) || E <- Value];
mask('*', Value) ->
    Value;
mask({'*', Submask}, Value) ->
    maps:map(fun(_, V) -> mask(Submask, V) end, Value);
mask({Key, Submask}, Value) when is_binary(Key) ->
    mask(Submask, mask(Key, Value));
mask(Mask, Value) when is_list(Mask)->
    maps:from_list(
      [{case E of
            {Key, _} ->
                Key;
            _ ->
                E
        end,
        mask(E, Value)}|| E <- Mask]);
mask(Key, Value) when is_binary(Key) ->
    maps:get(Key, Value).

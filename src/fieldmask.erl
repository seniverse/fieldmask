-module(fieldmask).

-export([mask/2, parse/1, apply_mask/2]).

-type value() :: null
                | number()
                | boolean()
                | binary()
                | [value()]
                | #{binary() => value()}.
%% type of a JSON value represented in jsone's map object format.

-type mask_expr() :: string() | binary().
%% type of mask expression. You may use a string or a binary as mask expression.

-type mask() :: '*'
              | {'*', mask()}
              | [submask()].

-type submask() :: binary()
                 | {binary(), mask()}.

%% @doc select the parts specified in the `Mask' expression of a `Value'
-spec mask(mask_expr(), value()) -> value().
mask(Mask, Value) ->
    {ok, M} = parse(Mask),
    apply_mask(M, Value).

%% @doc parse the `Mask' expression to internal representation
-spec parse(mask_expr()) -> Result
  when Result :: {ok, mask()} | Error,
       Error :: {error, {Line, module(), Reason}},
       Line :: pos_integer(),
       Reason :: term().
parse(Mask) ->
    case fieldmask_lexer:string(unicode:characters_to_list(Mask)) of
        {ok, Tokens, _} ->
            fieldmask_parser:parse(Tokens);
        {error, Error, _} ->
            {error, Error}
    end.

%% @doc apply `Mask' in internal representation to a `Value'
-spec apply_mask(mask(), value()) -> value().
apply_mask(Mask, Value) when is_list(Value) ->
    [apply_mask(Mask, E) || E <- Value];
apply_mask('*', Value) ->
    Value;
apply_mask({'*', Submask}, Value) ->
    maps:map(fun(_, V) -> apply_mask(Submask, V) end, Value);
apply_mask({Key, Submask}, Value) when is_binary(Key) ->
    apply_mask(Submask, apply_mask(Key, Value));
apply_mask(Mask, Value) when is_list(Mask)->
    maps:from_list(
      [{case E of
            {Key, _} ->
                Key;
            _ ->
                E
        end,
        apply_mask(E, Value)}|| E <- Mask]);
apply_mask(Key, Value) when is_binary(Key) ->
    maps:get(Key, Value).

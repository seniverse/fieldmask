-module(fieldmask_SUITE).

-include_lib("common_test/include/ct.hrl").
-compile(export_all).

all() ->
    [test_mask, test_lex_error, test_parse_error, test_parse].

test_mask(_Config) ->
    Data =
        #{
          <<"kind">> => <<"demo">>,
          <<"items">> =>
              [
               #{
                 <<"title">> => <<"First title">>,
                 <<"characteristics">> => #{ <<"length">> => <<"short">> },
                 <<"status">> => <<"active">>,
                 <<"pagemap">> =>
                     #{
                       <<"a">> =>
                           #{
                             <<"title">> => <<"a">>,
                             <<"page">> => 1
                            },
                       <<"b">> =>
                           #{
                             <<"title">> => <<"b">>
                            }
                      }
                },
               #{
                 <<"title">> => <<"Second title">>,
                 <<"characteristics">> => #{ <<"length">> => <<"long">> },
                 <<"status">> => <<"pending">>,
                 <<"pagemap">> => #{}
                }
              ]
         },

    Data = fieldmask:mask('*', Data),

    %% fields=kind
    Part1 = #{<<"kind">> => <<"demo">>},
    Part1 = fieldmask:mask([<<"kind">>], Data),

    %% fields=kind,items/title
    Part2 =
        #{<<"kind">> => <<"demo">>,
          <<"items">> =>
              [
               #{<<"title">> => <<"First title">>},
               #{<<"title">> => <<"Second title">>}
              ]},
    Part2 = fieldmask:mask([<<"kind">>, {<<"items">>, [<<"title">>]}], Data),

    Part3 =
        #{<<"kind">> => <<"demo">>,
          <<"items">> =>
              [
               #{<<"title">> => <<"First title">>,
                 <<"status">> => <<"active">>},
               #{<<"title">> => <<"Second title">>,
                 <<"status">> => <<"pending">>}
              ]},
    Part3 = fieldmask:mask([<<"kind">>, {<<"items">>, [<<"title">>, <<"status">>]}], Data),

    Part4 =
        #{<<"items">> =>
              [
               #{
                 <<"pagemap">> =>
                     #{
                       <<"a">> =>
                           #{
                             <<"title">> => <<"a">>,
                             <<"page">> => 1
                            },
                       <<"b">> =>
                           #{
                             <<"title">> => <<"b">>
                            }
                      }
                },
               #{
                 <<"pagemap">> => #{}
                }
              ]
         },

    %% items/pagemap/*
    Part4 = fieldmask:mask([{<<"items">>, [{<<"pagemap">>, '*'}]}], Data),

    Part5 =
        #{<<"items">> =>
              [
               #{
                 <<"pagemap">> =>
                     #{
                       <<"a">> =>
                           #{
                             <<"title">> => <<"a">>
                            },
                       <<"b">> =>
                           #{
                             <<"title">> => <<"b">>
                            }
                      }
                },
               #{
                 <<"pagemap">> => #{}
                }
              ]
         },

    %% items/pagemap/*/title
    Part5 = fieldmask:mask([{<<"items">>, [{<<"pagemap">>, {'*', [<<"title">>]}}]}], Data),
    ok.

test_lex_error(_Config) ->
    {error, {_, M, A}} = fieldmask:parse("."),
    <<"illegal characters \".\"">> = iolist_to_binary(M:format_error(A)),
    ok.

test_parse_error(_Config) ->
    {error, {_, M, A}} = fieldmask:parse("a("),
    <<"syntax error before: ">> = iolist_to_binary(M:format_error(A)),
    ok.

test_parse(_Config) ->
    {ok, '*'} = fieldmask:parse("*"),
    {ok, [<<"a">>]} = fieldmask:parse("a"),
    {ok, [<<"a">>, <<"b">>]} = fieldmask:parse("a,b"),
    {ok, [{<<"a">>, '*'}]} = fieldmask:parse("a/*"),
    {ok, [{<<"a">>, {'*', [<<"b">>]}}]} = fieldmask:parse("a/*/b"),
    {ok, [{<<"a">>, [<<"b">>, <<"c">>]}]} = fieldmask:parse("a(b,c)"),
    {ok, [{<<"a">>, [{<<"b">>, {'*', [<<"c">>, <<"d">>]}}, <<"e">>]}]} = fieldmask:parse("a(b/*(c,d),e)"),
    ok.

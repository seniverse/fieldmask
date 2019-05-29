## fieldmask

[![Build Status](https://travis-ci.org/seniverse/fieldmask.svg?branch=master)](https://travis-ci.org/seniverse/fieldmask)
[![Coverage Status](https://coveralls.io/repos/github/seniverse/fieldmask/badge.svg?branch=master)](https://coveralls.io/github/seniverse/fieldmask?branch=master)
[![hex.pm version](https://img.shields.io/hexpm/v/fieldmask.svg)](https://hex.pm/packages/fieldmask)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/fieldmask.svg)](https://hex.pm/packages/fieldmask)
![hex.pm license](https://img.shields.io/hexpm/l/fieldmask.svg)
![GitHub top language](https://img.shields.io/github/languages/top/seniverse/fieldmask.svg)

fieldmask implements Google [Partial Response](https://developers.google.com/+/web/api/rest/#partial-response) protocol in Erlang, like [json-mask](https://www.npmjs.com/package/json-mask) in JavaScript and [jsonmask](https://pypi.org/project/jsonmask/) in Python.

Mask of fieldmask is the same as `fields` parameter of Google+ API, for example, `<<"a,b">>` means the fields you want to keep is `"a"` and `"b"`.

```
1> Mask = <<"a,b">>.
<<"a,b">>
```

And fieldmask use map object format of [jsone](https://github.com/sile/jsone) to represent a JSON value.

```
2> Value = jsone:decode(<<"{\"a\":1, \"b\": 2, \"c\": 3}">>).
#{<<"a">> => 1,<<"b">> => 2,<<"c">> => 3}.
```

Call `fieldmask:mask/2` to get the specific parts of a value you've selected.

```
3> fieldmask:mask(Mask, Value).
#{<<"a">> => 1,<<"b">> => 2}
```


### Installation

add `fieldmask` dependency to your project's `rebar.config`

```
{deps, [fieldmask]}.
```


### License

fieldmask is released under Apache 2 License. Check [LICENSE](./LICENSE) file for more information.

# tasker

[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe badge]][lfe]
[![Erlang Versions][erlang badge]][version]
[![Tags][github tags badge]][github tags]

[![Project Logo][logo]][logo-large]

*An LFE application for running recurring tasks*

##### Table of Contents

* [About](#about-)
* [Build](#build-)
* [Start the Project REPL](#start-the-repl-)
* [Tests](#tests-)
* [Usage](#usage-)
* [License](#license-)

## About [&#x219F;](#table-of-contents)

The `tasker` tool simply takes configuration that describes one or more OS CLI calls and executes them reguarly at the configured interval. Task metadata takes the following form:

``` erlang
[{name, String},
 {cmd, String},
 {args, [term] | []},
 {interval, Integer}
]
```

And a complete configiration takes the form:

``` erlang
[{tasker,
  [{tasks, [metadata, ...]}]
}].
```

See `./priv/examples` for working configs.

## Build [&#x219F;](#table-of-contents)

Note that, due to the use of the safer `timer:apply_repeatedly`, this project requires Erlang 26 or later.

```shell
$ rebar3 lfe compile
```

## Start the Project REPL [&#x219F;](#table-of-contents)

```shell
$ rebar3 lfe repl
```

## Tests [&#x219F;](#table-of-contents)

```shell
$ rebar3 as test lfe test
```

## Usage [&#x219F;](#table-of-contents)

Run the date example, calling out to the system shell every 5 seconds to get the system date:

``` shell
erl -noshell -pa $(rebar3 path) \
  -config priv/examples/shell-date.config \
  -run tasker start
```

Run the example that configures multiple recurring tasks:

``` shell
erl -noshell -pa $(rebar3 path) \
  -config priv/examples/multiple.config \
  -run tasker start
```

For convenience, a shell script has been added that allows one to run a config like so:

``` shell
./bin/tasker priv/examples/multiple.config
```

An alternative that executes the call as a background OS process:

``` shell
./bin/taskerd priv/examples/multiple.config
```

## License [&#x219F;](#table-of-contents)

Apache License, Version 2.0

Copyright © 2023, Duncan McGreggor <oubiwann@gmail.com>.

[//]: ---Named-Links---

[logo]: priv/images/logo.png
[logo-large]: priv/images/logo-large.png
[github]: https://github.com/lfeutre/tasker
[gitlab]: https://gitlab.com/lfeutre/tasker
[gh-actions-badge]: https://github.com/lfeutre/tasker/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfeutre/tasker/actions?query=workflow%3Acicd
[lfe]: https://github.com/lfe/lfe
[lfe badge]: https://img.shields.io/badge/lfe-2.1-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-26+-blue.svg
[version]: https://github.com/lfeutre/tasker/blob/master/.github/workflows/cicd.yml
[github tags]: https://github.com/lfeutre/tasker/tags
[github tags badge]: https://img.shields.io/github/tag/lfeutre/tasker.svg
[github downloads]: https://img.shields.io/github/downloads/lfeutre/tasker/total.svg

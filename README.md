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

TBD

## Build [&#x219F;](#table-of-contents)

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

Run the date example, calling out to the shell every 5 seconds to get the system date:

``` shell
erl -noshell -pa $(rebar3 path) \
  -config priv/examples/shell-date.config \
  -run tasker start
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
[erlang badge]: https://img.shields.io/badge/erlang-19%20to%2025-blue.svg
[version]: https://github.com/lfeutre/tasker/blob/master/.github/workflows/cicd.yml
[github tags]: https://github.com/lfeutre/tasker/tags
[github tags badge]: https://img.shields.io/github/tag/lfeutre/tasker.svg
[github downloads]: https://img.shields.io/github/downloads/lfeutre/tasker/total.svg

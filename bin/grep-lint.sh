#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all lint/prettier/coverage override references and TODO like comments in files under git control
# See also git-mustdo.sh mustdo.sh
# WINDEV tool useful on windows development machine
git grep -E '(/[\*/]|<!--|#)\s*(((es|style)lint|prettier|global|js[hl]int|jscs:?|sonar|TODO|MUSTDO|HACK|FIXME)[a-z-]*|istanbul ignore( [a-z]+)?)' $*

exit $?


https://eslint.org/docs/user-guide/configuring

/* eslint max-len: 120 */

/* eslint-env node, mocha */

/* global var1:writable */

// eslint-disable-next-line

// eslint-disable-next-line max-len

// eslint-disable-line

// eslint-disable-line max-len

/* eslint-disable */
/* eslint-enable */

/* eslint-disable max-len */
/* eslint-enable max-len */

https://prettier.io/docs/en/ignore.html

JS CSS

// prettier-ignore
...

/* prettier-ignore */
...

JSX
<div>
	{/* prettier-ignore */}
	...
</div>

HTML MARKDOWN
<!-- prettier-ignore-start -->
...
<!-- prettier-ignore-end -->

<!-- prettier-ignore-attribute -->
<div id   =   "            id          ">
</div>

<!-- prettier-ignore-attribute (mouseup) -->

GRAPHQL
# prettier-ignore

Istanbul
https://github.com/gotwarlost/istanbul/blob/master/ignoring-code-for-coverage.md

/* istanbul ignore <word>[non-word] [optional-docs] */

/* istanbul ignore if */

/* istanbul ignore else */

/* istanbul ignore next */

/* istanbul ignore next: tired of writing tests */

Sonar
https://docs.sonarqube.org/latest/project-administration/narrowing-the-focus/

/* sonar ... actually is fully customisable so could be anything */

/* jslint max-len */

https://stackoverflow.com/questions/32424795/jshint-and-jscs-inline-ignore-for-the-same-next-line/32754878

/* jshint max-len */
/* jshint ignore:start */
/* jshint ignore:end */

/* jscs:disable */
/* jscs:enable */

/* TODO ... */
/* MUSTDO ... */
/* FIXME ... */
/* HACK ... */

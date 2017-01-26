# `rules_typescript` [![Build Status](https://travis-ci.org/pubref/rules_typescript.svg?branch=master)](https://travis-ci.org/pubref/rules_typescript)

<table><tr>
<td><img src="https://avatars1.githubusercontent.com/u/11684617?v=3&s=200" height="120"/></td>
<td><img src="https://raw.githubusercontent.com/remojansen/logo.ts/master/ts.png" height="120"/></td>
<td><img src="https://3.bp.blogspot.com/-PpegKkYIbEY/V8YbCiGqcmI/AAAAAAAACJw/HvSXgYS_ORc5T_LDHmk4PDRwXQMYd-RNACLcB/s1600/image00.png" height="120"/></td>
</tr><tr>
<td>Bazel</td>
<td>Typescript</td>
<td>rules_closure</td>
</tr></table>

Strongly typed typescript goes in, optimized & minified javascript
comes out; seasoned with copious amounts of amesomesauce.


## Rules

|               Name   |  Description |
| -------------------: | :----------- |
| [typescript_repositories](#typescript_repositories) |  Load dependencies for this repository. |
| [ts_library](#ts_library) | Invoke the typescript compiler on a set of `*.ts` files to generate a set of `*.js` files. |
| [ts_binary](#ts_binary) | Optimize and minify a set of `*.js` files with closure compiler via rules_closure. |

**Status**: PROOF OF CONCEPT.  It probably only works under very
  narrow conditions at the moment.

## Usage

Prerequisite: java8 and bazel should installed on your system.

### WORKSPACE Configuration

#### 1. Add rules_closure to your WORKSPACE

```python
git_repository(
  name = "io_bazel_rules_closure",
  remote = "https://github.com/bazelbuild/rules_closure",
  tag = "0.4.0",
)
```

This brings in rules_closure, which is actually a different front-end
to the closure compiler with additional type checking and goodies.

#### 2. Add rules_node to your WORKSPACE

```python
git_repository(
  name = "org_pubref_rules_node",
  remote = "https://github.com/pubref/rules_node",
  commit = HEAD, # replace with latest version
)
```

This brings in an independent copy of node, typescript (2.1.4), and
tsickle (0.21.0, experimental).

#### 3. Add rules_typescript to your WORKSPACE

```python
git_repository(
  name = "org_pubref_rules_typescript",
  remote = "https://github.com/pubref/rules_typescript",
  commit = HEAD, # replace with latest version
)

load("@org_pubref_rules_typescript//ts:rules.bzl", "ts_repositories")
ts_repositories()
```

### BUILD Configuration

#### ls_library

Compile typescript files with `tsc`, the typescript compiler.

```python
load("@org_pubref_rules_typescript//ts:rules.bzl", "ts_library")

ts_library(
  name = "lib",
  srcs = [
    "a.ts",
    "b.ts",
    "c.ts",
  ],
  # Optional tsconfig file.  If provided, you don't need to specify 'files'.
  ts_config = "tsconfig.json",
)
```

#### ls_binary

Compile generated javascript from ts_library dependencies into single
minified output via the `closure_js_binary` rule.

```python
load("@org_pubref_rules_typescript//ts:rules.bzl", "ts_binary")

ts_binary(
  name = "app",
  deps = [
    ":lib",
  ],
)
```

The generated file will take the form:

```javascript
var {TS_BINARY_RULE_NAME} = function(){%output%};
```

Therefore, you can invoke the entry point for the minified bundle:

```html
<html>
 <head>
  <script src="{TS_BINARY_RULE_NAME}.js"></script>

 </head>
 ...
 <script>{TS_BINARY_RULE_NAME}();</script>
</html>
```

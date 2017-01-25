# `rules_maven` [![Build Status](https://travis-ci.org/pubref/rules_maven.svg?branch=master)](https://travis-ci.org/pubref/rules_maven)

<table><tr>
<td><img src="https://avatars1.githubusercontent.com/u/11684617?v=3&s=200" height="120"/></td>
<td><img src="http://studentaffairs.uci.edu/resources/right-facing-blk-outline.png" height="120"/></td>
</tr><tr>
<td>Rules</td>
<td>Maven</td>
</tr></table>

[Bazel](https://bazel.build) rules for working with transitive maven dependencies.

## Rules

|               Name   |  Description |
| -------------------: | :----------- |
| [maven_repositories](#maven_repositories) |  Load dependencies for this repo. |
| [maven_repository](#maven_repository) | Declare an external workspace that defines transitive dependencies for a set of maven artifacts. |

**Status**: experimental, but actively in use for other internal projects.

## Usage

### 1. Add rules_maven to your WORKSPACE

```python
git_repository(
  name = "org_pubref_rules_maven",
  remote = "https://github.com/pubref/rules_maven",
  commit = HEAD, # replace with latest version
)

load("@org_pubref_rules_maven//maven:rules.bzl", "maven_repositories")
maven_repositories()
```

### 2a. Define an initial maven_repository rule naming the root artifact(s)

```python
load("@org_pubref_rules_maven//maven:rules.bzl", "maven_repository")

maven_repository(
  name = "guice",
  deps = [
    'com.google.inject:guice:4.1.0',
  ],
)
```

Given this initial repository rule defintion, `rules_maven` will:

1. write a `build.gradle` file,

1. install `gradle` as it's own internal dependency (first time only;
   does not interfere with any other gradle you might have installed).

1. call `gradle dependencies` and parse the output,

1. fetch the expected sha1 values for named artifacts,

1. write a `@guice//:rules.bzl` file having the requisite `maven_jar`
   rules (organized by configuration),

1. write a `@guice//:BUILD` file with the requisite `java_library`
   that bundle/export dependencies (one per configuration).

1. print out a formatted `maven_repository` *"closed-form"* rule with
   all the transitive dependencies explicitly named.

### 2b. Copy and paste the closed-form back into your WORKSPACE.

`rules_maven` will regurgitate a so-called *closed-form*
`maven_repository` rule enumerating the transitive dependencies and
their sha1 values in the `transitive_deps` attribute.  Assuming you
trust the data, copy and paste this back into your `WORKSPACE`.

```python
maven_repository(
  name = 'guice',
  deps = [
    'com.google.inject:guice:4.1.0',
  ],
  transitive_deps = [
    '0235ba8b489512805ac13a8f9ea77a1ca5ebe3e8:aopalliance:aopalliance:1.0',
    '6ce200f6b23222af3d8abb6b6459e6c44f4bb0e9:com.google.guava:guava:19.0',
    'eeb69005da379a10071aa4948c48d89250febb07:com.google.inject:guice:4.1.0',
    '6975da39a7040257bd51d21a231b76c915872d38:javax.inject:javax.inject:1',
  ],
)
```

Once the `transitive_deps` is stable (all transitive deps and their correct
sha1 values are listed), `rules_maven` will be silent.

### 3. Load the `@guice//:rules.bzl` file in your WORKSPACE and invoke the desired macro configuration.

The `rules.bzl` file (a generated file) contains macro definitions
that ultimately define `native.maven_jar` rules.  A separate macro is
defined for each *gradle configuration*.  The default configurations
are: `compile`, `runtime`, `compileOnly`, `compileClasspath`,
`testCompile`, and `testRuntime`.  (these can be customized via the
`configurations` attribute).

The name of the macros are the gradle configuration name, prefixed
with the rule name.  In this case there are the following macros (and
several others):

* `guice_compile`: Provide compile-time dependencies.
* `guice_runtime`: Provide runtime-time dependencies.
* ...


```python
load("@guice//:rules.bzl", "guice_compile")
guice_compile()
```

> In this case, both `_compile` and `_runtime` macros provide the same dependencies.

> You can inspect the contents of the generated file via:

```sh
$ cat $(bazel info output_base)/external/guice/rules.bzl
```

### 4. Depend on the java_library rule for the desired configuration.

```python
java_binary(
  name = "app",
  main_class = "example.App",
  deps = ["@guice//:compile"],
)
```
\java_library(
  name = 'compile',
  exports = [
    '@aopalliance_aopalliance//jar',
    '@com_google_guava_guava//jar',
    '@com_google_inject_guice//jar',
    '@javax_inject_javax_inject//jar',
  ],
  visibility = ['//visibility:public'],
)
### Final WORKSPACE

To further illustrate steps 1-3 are all in the same file.

```python
git_repository(
  name = "org_pubref_rules_maven",
  remote = "https://github.com/pubref/rules_maven",
  commit = HEAD, # replace with latest version
)
load("@org_pubref_rules_maven//maven:rules.bzl", "maven_repositories", "maven_repository")
maven_repositories()


maven_repository(
  name = 'guice',
  deps = [
    'com.google.inject:guice:4.1.0',
  ],
  transitive_deps = [
    '0235ba8b489512805ac13a8f9ea77a1ca5ebe3e8:aopalliance:aopalliance:1.0',
    '6ce200f6b23222af3d8abb6b6459e6c44f4bb0e9:com.google.guava:guava:19.0',
    'eeb69005da379a10071aa4948c48d89250febb07:com.google.inject:guice:4.1.0',
    '6975da39a7040257bd51d21a231b76c915872d38:javax.inject:javax.inject:1',
  ],
)
load("@guice//:rules.bzl", "guice_compile")
guice_compile()
```

# Credits

The anteater image is a reference to the O'Reilly book cover.  This image is
actually "Peter", the University of California Irvine
mascot. [**ZOT!**](http://studentaffairs.uci.edu/resources/right-facing-blk-outline.png)

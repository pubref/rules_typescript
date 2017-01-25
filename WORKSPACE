workspace(name = "org_pubref_rules_typescript")

git_repository(
    name = "io_bazel_rules_closure",
    remote = "https://github.com/bazelbuild/rules_closure.git",
    tag = "0.4.0",
)
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_repositories")
closure_repositories()

git_repository(
    name = "org_pubref_rules_node",
    remote = "https://github.com/pubref/rules_node.git",
    tag = "v0.3.2",
)
load("@org_pubref_rules_node//node:rules.bzl", "node_repositories")
node_repositories()

load("//ts:rules.bzl", "ts_repositories")
ts_repositories()

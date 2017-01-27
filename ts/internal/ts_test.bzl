load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_test")
load("@org_pubref_rules_node//node:rules.bzl", "mocha_test")
load("//ts:internal/ts_library.bzl", "ts_library")

def ts_test(name, main, deps, mocha_args = []):
    mocha_test(
        name = name,
        main = main,
        mocha_args = mocha_args
    )
# https://journal.artfuldev.com/write-tests-for-typescript-projects-with-mocha-and-chai-in-typescript-86e053bdb2b6#.4lzf22krp

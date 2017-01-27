load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_binary", "closure_js_library", "closure_js_test")
load("//ts:internal/ts_library.bzl", "ts_library")

def ts_binary(name,
              srcs = [],
              deps = [],
              debug = False,
              compilation_level = "ADVANCED",
):

    ts_library(
        name = 'ts' + name,
        srcs = srcs,
        deps = deps,
    )

    closure_js_library(
        name = 'cl' + name,
        srcs = ['ts' + name],
    )

    closure_js_binary(
        name = name,
        compilation_level = compilation_level,
        debug = False,
        defs = [
            "--process_common_js_modules",
        ],
        #entry_points = entry_points,
        output_wrapper = "var " + name + " = function(){%output%};",
        deps = ['cl' + name],
    )

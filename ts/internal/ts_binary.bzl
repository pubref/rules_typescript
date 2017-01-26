load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_binary", "closure_js_library")
load("//ts:internal/ts_library.bzl", "ts_library")

def _get_js_filename(f):
    parts = f.rsplit('.', 1);
    return parts[0] + '.js';

def ts_binary(name, srcs = [], deps = []):

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
        compilation_level = "SIMPLE",
        debug = True,
        defs = [
            "--transform_amd_modules",
            "--process_common_js_modules",
        ],
        #entry_points = entry_points,
        #entry_points = ["goog:bzl.boot"],
        output_wrapper = "var " + name + " = function(){%output%};",
        deps = ['cl' + name],
    )

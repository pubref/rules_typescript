load("//ts:rules.bzl", "ts_library", "ts_binary")

ts_library(
    name = "hlib",
    srcs = [
        "hello.ts",
        "app.ts",
    ],
)

ts_binary(
    name = "app_bin",
    deps = [
        ":hlib"
    ]
)

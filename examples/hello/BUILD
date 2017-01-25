load("//ts:rules.bzl", "ts_library", "ts_binary")

ts_library(
    name = "hello",
    srcs = [
        "hello.ts",
        "app.ts",
    ],
)

ts_binary(
    name = "app",
    srcs = [
        "app.ts",
    ],
    deps = [
        ":hello"
    ]
)

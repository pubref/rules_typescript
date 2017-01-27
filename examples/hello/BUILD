load("//ts:rules.bzl", "ts_library", "ts_binary", "ts_test")

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
    ],
)

ts_test(
    name = "app_test",
    main = "app_test.ts",
    deps = [
        ":hlib",
    ],
    mocha_args = [
        "--register ts-node2/register"
    ],
)

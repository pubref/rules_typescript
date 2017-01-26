_ts_filetype = FileType([".ts", ".js"])
_json_filetype = FileType([".json"])

TSCONFIG = """
{
  "compilerOptions": {
    "experimentalDecorators": true,
    "module": "commonjs",
    "declaration": true,
    "noImplicitAny": true,
    "noEmitOnError": true,
    "target": "es5",
    "lib": ["es5", "es6", "es2015.collection", "es2015.iterable", "dom"],
    "jsx": "react",
    "types": ["node", "mocha"],
    "strictNullChecks": true
  },
  "files": [
    {files}
  ]
}
"""

def ts_library_impl(ctx):
    node = ctx.executable._node
    tsc = ctx.file._tsc
    tsickle = ctx.file._tsickle
    compiler = tsickle if ctx.attr.sick else tsc
    tsconfig = ctx.file.tsconfig

    srcs = ctx.files.srcs
    data = []

    for d in ctx.attr.data:
        for file in d.files:
            data.append(file)

    for dep in ctx.attr.deps:
        lib = dep.ts_library
        srcs += lib.srcs

    srcs_js = [ctx.new_file("%s.js" % src.basename) for src in srcs]

    args = [
        node.path,
        compiler.path,
    ]

    # if ctx.attr.sick:
    #     args += ["--externs=" + extfile.path]
    #     args += ["--"]

    args += ["--module", "amd"]

    if (srcs):
        for file in srcs:
            args.append(file.path)
    else:
        args += ["-p", tsconfig.dirname]

    ctx.action(
        mnemonic = "TypesciptCompile",
        inputs = [node, compiler, tsconfig] + srcs,
        outputs = srcs_js,
        command = " ".join(args),
        env = {
            "NODE_PATH": tsc.dirname + "/..",
        },
    )

    return struct(
        files = set(srcs_js),
        ts_library = struct(
            srcs = srcs,
        ),
    )

ts_library = rule(
    ts_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = _ts_filetype,
        ),
        "data": attr.label_list(
            allow_files = True,
            cfg = "data",
        ),
        "deps": attr.label_list(
            providers = ["ts_library"],
        ),
        "tsconfig": attr.label(
            single_file = True,
            allow_files = _json_filetype,
            default = Label("//ts:tsconfig.json"),
        ),
        "sick": attr.bool(
            default = True,
        ),
        "_node": attr.label(
            default = Label("@org_pubref_rules_node_toolchain//:node_tool"),
            single_file = True,
            allow_files = True,
            executable = True,
            cfg = "host",
        ),
        "_tsc": attr.label(
            default = Label("@typescript//:bin/tsc"),
            single_file = True,
            allow_files = True,
            cfg = "host",
        ),
        "_tsickle": attr.label(
            default = Label("@typescript//:bin/tsickle"),
            single_file = True,
            allow_files = True,
            cfg = "host",
        ),
    },
)

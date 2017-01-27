load("@org_pubref_rules_node//node:rules.bzl", "npm_repository")

def ts_repositories():
    npm_repository(
        name = "typescript",
        deps = {
            "typescript": "2.1.4",
            "tsickle": "0.21.0",
        },
    )
    npm_repository(
        name = "testing",
        deps = {
            "@types/mocha": "2.2.3.8",
            "@types/": "2.1.0",
        },
    )

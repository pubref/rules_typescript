load("@org_pubref_rules_node//node:rules.bzl", "npm_repository")

def ts_repositories():
    npm_repository(
        name = "typescript",
        deps = {
            "typescript": "2.1.4",
            "tsickle": "0.21.0",
        },
    )

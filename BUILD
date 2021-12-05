load("@build_bazel_rules_apple//apple:macos.bzl", "macos_command_line_application")

objc_library(
    name = "Lib",
    srcs = glob([ "*.m*" ]),
    hdrs = glob([ "*.h" ]),
)

macos_command_line_application(
    name = "aoc",
    bundle_id = "kfm.aoc-2021",
    infoplists = [":Info.plist"],
    minimum_os_version = "10.11",
    deps = [":Lib"],
)

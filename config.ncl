# config.ncl - Nickel configuration for ReScript Evangeliser
# SPDX-License-Identifier: MIT OR Palimpsest-0.8
#
# Type-safe configuration using Nickel

{
  project = {
    name = "rescript-evangeliser",
    version = "0.1.0",
    description = "Learn ReScript through progressive code transformation",
    license = "MIT OR Palimpsest-0.8",
  },

  # Language policy
  languages = {
    allowed = [
      "ReScript",
      "Deno",
      "Rust",
      "Bash",
      "JavaScript",  # Only for VS Code API bindings
      "Nickel",
    ],

    banned = [
      "TypeScript",
      "Node.js",
      "npm",
      "bun",
      "Go",
    ],

    primary = "ReScript",
    runtime = "Deno",
  },

  # Build configuration
  build = {
    tool = "just",
    package_manager = "deno",

    tasks = {
      build = "deno task build",
      clean = "deno task clean",
      validate = "deno task validate",
      test = "deno task test",
      fmt = "deno task fmt",
      lint = "deno task lint",
    },
  },

  # Paths
  paths = {
    src = "src",
    scripts = "scripts",
    docs = "docs",
    lib = "lib",
  },

  # CI configuration
  ci = {
    platforms = ["ubuntu-latest"],
    required_checks = [
      "ts-blocker",
      "makefile-blocker",
      "npm-bun-blocker",
      "validate",
      "build",
      "test",
    ],
  },

  # ReScript configuration
  rescript = {
    version = "11",
    module_format = "es6",
    suffix = ".res.js",
    uncurried = true,
  },
}

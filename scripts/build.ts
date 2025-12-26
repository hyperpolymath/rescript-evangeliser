// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Build script for ReScript Evangeliser
// Uses Deno for build orchestration

import { ensureDir, exists } from "@std/fs"
import { join } from "@std/path"

const ROOT = Deno.cwd()
const SRC_DIR = join(ROOT, "src")
const OUT_DIR = join(ROOT, "lib")

async function runCommand(cmd: string[]): Promise<boolean> {
  console.log(`Running: ${cmd.join(" ")}`)
  const command = new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    stdout: "inherit",
    stderr: "inherit",
  })
  const result = await command.output()
  return result.success
}

async function buildReScript(): Promise<boolean> {
  console.log("Building ReScript sources...")

  // Check if rescript.json exists
  if (!(await exists(join(ROOT, "rescript.json")))) {
    console.error("Error: rescript.json not found")
    return false
  }

  // Run ReScript compiler
  const success = await runCommand(["npx", "rescript", "build"])
  if (success) {
    console.log("ReScript build completed successfully")
  }
  return success
}

async function copyAssets(): Promise<void> {
  console.log("Preparing output directory...")
  await ensureDir(OUT_DIR)
}

async function main(): Promise<void> {
  console.log("=== ReScript Evangeliser Build ===\n")

  await copyAssets()

  const success = await buildReScript()

  if (success) {
    console.log("\n Build completed successfully!")
  } else {
    console.error("\n Build failed!")
    Deno.exit(1)
  }
}

main()

// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Clean script for ReScript Evangeliser

import { exists } from "@std/fs"
import { join } from "@std/path"

const ROOT = Deno.cwd()

const CLEAN_TARGETS = [
  "lib",
  ".bsb.lock",
  "node_modules/.cache",
  // ReScript generated files
  "src/**/*.res.js",
  "src/**/*.bs.js",
  "src/**/*.mjs",
]

async function cleanDir(path: string): Promise<void> {
  const fullPath = join(ROOT, path)
  if (await exists(fullPath)) {
    console.log(`Removing: ${path}`)
    await Deno.remove(fullPath, { recursive: true })
  }
}

async function cleanGlob(pattern: string): Promise<void> {
  // Simple glob handling for common patterns
  if (pattern.includes("**")) {
    const basePath = pattern.split("**")[0]
    const extension = pattern.split("*").pop() || ""

    const fullBasePath = join(ROOT, basePath)
    if (!(await exists(fullBasePath))) return

    async function walkAndClean(dir: string): Promise<void> {
      for await (const entry of Deno.readDir(dir)) {
        const entryPath = join(dir, entry.name)
        if (entry.isDirectory) {
          await walkAndClean(entryPath)
        } else if (entry.name.endsWith(extension)) {
          console.log(`Removing: ${entryPath.replace(ROOT + "/", "")}`)
          await Deno.remove(entryPath)
        }
      }
    }

    await walkAndClean(fullBasePath)
  } else {
    await cleanDir(pattern)
  }
}

async function main(): Promise<void> {
  console.log("=== ReScript Evangeliser Clean ===\n")

  for (const target of CLEAN_TARGETS) {
    if (target.includes("*")) {
      await cleanGlob(target)
    } else {
      await cleanDir(target)
    }
  }

  console.log("\n Clean completed!")
}

main()

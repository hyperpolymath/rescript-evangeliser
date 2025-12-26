// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Validation script for ReScript Evangeliser
// Validates project structure and policy compliance

import { exists } from "@std/fs"
import { join } from "@std/path"

const ROOT = Deno.cwd()

interface ValidationResult {
  name: string
  passed: boolean
  message: string
}

const results: ValidationResult[] = []

function log(emoji: string, message: string): void {
  console.log(`${emoji} ${message}`)
}

function pass(name: string, message: string): void {
  results.push({ name, passed: true, message })
  log("", `${name}: ${message}`)
}

function fail(name: string, message: string): void {
  results.push({ name, passed: false, message })
  log("", `${name}: ${message}`)
}

async function validateStructure(): Promise<void> {
  log("", "Checking project structure...")

  const requiredFiles = [
    "rescript.json",
    "deno.json",
    "justfile",
    "README.adoc",
    "CLAUDE.md",
    "SECURITY.md",
    "CONTRIBUTING.md",
    "CODE_OF_CONDUCT.md",
    "LICENSE-MIT.txt",
    "LICENSE-PALIMPSEST.txt",
  ]

  for (const file of requiredFiles) {
    if (await exists(join(ROOT, file))) {
      pass("Structure", `Found ${file}`)
    } else {
      fail("Structure", `Missing ${file}`)
    }
  }

  const requiredDirs = ["src", "docs", ".github"]

  for (const dir of requiredDirs) {
    if (await exists(join(ROOT, dir))) {
      pass("Structure", `Found ${dir}/`)
    } else {
      fail("Structure", `Missing ${dir}/`)
    }
  }
}

async function validateNoMakefile(): Promise<void> {
  log("📋", "Checking for banned Makefile...")

  if (await exists(join(ROOT, "Makefile"))) {
    fail("Policy", "Makefile detected - use justfile instead")
  } else if (await exists(join(ROOT, "makefile"))) {
    fail("Policy", "makefile detected - use justfile instead")
  } else if (await exists(join(ROOT, "GNUmakefile"))) {
    fail("Policy", "GNUmakefile detected - use justfile instead")
  } else {
    pass("Policy", "No Makefile found (using justfile)")
  }
}

async function validateNoNewTypeScript(): Promise<void> {
  log("📜", "Checking for TypeScript/JavaScript in src/...")

  const srcDir = join(ROOT, "src")
  if (!(await exists(srcDir))) {
    pass("Policy", "No src/ directory to check")
    return
  }

  let foundTS = false
  let foundJS = false

  async function walkDir(dir: string): Promise<void> {
    for await (const entry of Deno.readDir(dir)) {
      const entryPath = join(dir, entry.name)
      if (entry.isDirectory) {
        await walkDir(entryPath)
      } else {
        if (entry.name.endsWith(".ts") || entry.name.endsWith(".tsx")) {
          foundTS = true
          fail("Policy", `TypeScript file in src/: ${entry.name}`)
        }
        if (
          (entry.name.endsWith(".js") || entry.name.endsWith(".jsx")) &&
          !entry.name.endsWith(".res.js") &&
          !entry.name.endsWith(".bs.js")
        ) {
          foundJS = true
          fail("Policy", `JavaScript file in src/: ${entry.name}`)
        }
      }
    }
  }

  await walkDir(srcDir)

  if (!foundTS && !foundJS) {
    pass("Policy", "No TypeScript/JavaScript in src/ (ReScript only)")
  }
}

async function validateReScriptFiles(): Promise<void> {
  log("🔷", "Checking for ReScript source files...")

  const srcDir = join(ROOT, "src")
  if (!(await exists(srcDir))) {
    fail("ReScript", "No src/ directory found")
    return
  }

  let resCount = 0

  async function walkDir(dir: string): Promise<void> {
    for await (const entry of Deno.readDir(dir)) {
      const entryPath = join(dir, entry.name)
      if (entry.isDirectory) {
        await walkDir(entryPath)
      } else if (entry.name.endsWith(".res")) {
        resCount++
      }
    }
  }

  await walkDir(srcDir)

  if (resCount > 0) {
    pass("ReScript", `Found ${resCount} ReScript source files`)
  } else {
    fail("ReScript", "No ReScript (.res) files found in src/")
  }
}

async function validateSPDXHeaders(): Promise<void> {
  log("", "Checking SPDX license headers in ReScript files...")

  const srcDir = join(ROOT, "src")
  if (!(await exists(srcDir))) {
    return
  }

  let checked = 0
  let withHeaders = 0

  async function walkDir(dir: string): Promise<void> {
    for await (const entry of Deno.readDir(dir)) {
      const entryPath = join(dir, entry.name)
      if (entry.isDirectory) {
        await walkDir(entryPath)
      } else if (entry.name.endsWith(".res")) {
        checked++
        const content = await Deno.readTextFile(entryPath)
        if (content.includes("SPDX-License-Identifier:")) {
          withHeaders++
        } else {
          fail("SPDX", `Missing SPDX header: ${entry.name}`)
        }
      }
    }
  }

  await walkDir(srcDir)

  if (checked === withHeaders && checked > 0) {
    pass("SPDX", `All ${checked} ReScript files have SPDX headers`)
  }
}

async function main(): Promise<void> {
  console.log("=== ReScript Evangeliser Validation ===\n")

  await validateStructure()
  await validateNoMakefile()
  await validateNoNewTypeScript()
  await validateReScriptFiles()
  await validateSPDXHeaders()

  console.log("\n=== Summary ===")

  const passed = results.filter((r) => r.passed).length
  const failed = results.filter((r) => !r.passed).length

  console.log(`Passed: ${passed}`)
  console.log(`Failed: ${failed}`)

  if (failed > 0) {
    console.log("\n Validation failed!")
    Deno.exit(1)
  } else {
    console.log("\n Validation passed!")
  }
}

main()

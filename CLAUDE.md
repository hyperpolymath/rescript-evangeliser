# CLAUDE.md

## Project Overview

**ReScript Evangeliser** is a project dedicated to promoting and advocating for the ReScript programming language. ReScript is a robustly typed language that compiles to efficient and human-readable JavaScript.

## Project Purpose

This repository serves as a resource hub for:
- Educational materials about ReScript
- Example projects and code snippets
- Tools and utilities to help developers adopt ReScript
- Community content to evangelize ReScript's benefits

## Technology Stack

### Core Technologies
- **ReScript**: Primary application code - compiles to JS, type-safe
- **Deno**: Runtime & package management - replaces Node/npm/bun
- **Nickel**: Configuration language - type-safe config

### Language Policy (Hyperpolymath Standard)

**ALLOWED:**
- ReScript (primary application code)
- Deno (runtime & package management)
- Bash/POSIX Shell (scripts, automation)
- JavaScript (only where ReScript cannot - minimal glue code)
- Nickel (configuration)

**BANNED:**
- TypeScript (use ReScript)
- Node.js (use Deno)
- npm/bun (use Deno)
- Makefile (use justfile)

### Key ReScript Features to Understand
- **Type Safety**: 100% sound type system with excellent inference
- **Fast Compilation**: Compiles to readable JavaScript in milliseconds
- **JavaScript Interop**: Seamless integration with existing JavaScript code
- **Functional Programming**: First-class support for functional patterns
- **Pattern Matching**: Powerful pattern matching with exhaustiveness checking

## Project Structure

```
rescript-evangeliser/
├── src/              # ReScript source files (.res)
│   ├── Types.res     # Core type definitions
│   ├── Glyphs.res    # Makaton-inspired glyph system
│   ├── Narrative.res # Encouraging narrative generation
│   └── Patterns.res  # Pattern library (50+ patterns)
├── scripts/          # Deno build/validation scripts
├── docs/             # Documentation and guides
├── rescript.json     # ReScript build configuration
├── deno.json         # Deno configuration
├── justfile          # Task orchestration (NOT Makefile)
├── Mustfile.epx      # Deployment contract
└── config.ncl        # Nickel configuration
```

## Development Guidelines

### Code Style
- Follow ReScript's official style guide
- Use meaningful variable and function names
- Prefer pattern matching over if/else when appropriate
- Leverage the type system to make invalid states unrepresentable
- Write interface files (.resi) for public APIs
- Add SPDX license headers to all source files

### Best Practices
1. **Type-First Design**: Design types before implementation
2. **Immutability**: Prefer immutable data structures
3. **Pure Functions**: Write pure functions when possible
4. **Documentation**: Document complex type definitions and public APIs
5. **Error Handling**: Use Result and Option types instead of exceptions

### ReScript-Specific Patterns
- Use `@react.component` for React components
- Leverage pipe operator (`->`) for data transformations
- Use labeled arguments for better API clarity
- Prefer records over tuples for structured data
- Use variants for state machines and tagged unions

## Common Commands

```bash
# Install dependencies
just install

# Build the project
just build

# Watch mode for development
just watch

# Clean build artifacts
just clean

# Run tests
just test

# Validate project structure and policy
just validate

# Format code
just fmt

# Full validation
just validate-rsr
```

## Working with ReScript

### Module System
- Each .res file is automatically a module
- Modules are capitalized (filename.res becomes Filename module)
- Use .resi files to define module interfaces
- Modules can be nested using module bindings

### JavaScript Interop
- Use `@module` for importing JS modules
- Use `@val` for accessing global values
- Use `@send` for calling JS methods
- Raw JS can be embedded with `%%raw()`

### Type Definitions
- External JavaScript libraries need ReScript bindings
- Create bindings in separate files (e.g., `ExternalLib.res`)
- Consider contributing bindings to @rescript community packages

## Build System

This project uses:
- **Deno**: For build scripts and task running
- **justfile**: For task orchestration (NOT Makefile)
- **ReScript**: Uses its own compiler (rescript/bsb)

### Key Configuration Files

**rescript.json**
```json
{
  "name": "rescript-evangeliser",
  "sources": ["src"],
  "package-specs": { "module": "es6", "in-source": true },
  "suffix": ".res.js",
  "uncurried": true
}
```

**deno.json**
```json
{
  "tasks": {
    "build": "deno run -A scripts/build.ts",
    "validate": "deno run -A scripts/validate.ts"
  }
}
```

## Dependencies

### Runtime
- Deno (latest stable)
- ReScript 11+
- @rescript/core

### Package Management
- **Primary**: Guix (guix.scm)
- **Fallback**: Nix (flake.nix)
- **JS deps**: Deno (deno.json imports)

## Evangelism Goals

1. **Demonstrate Value**: Show concrete benefits of ReScript
2. **Lower Barriers**: Make adoption as easy as possible
3. **Share Success Stories**: Document real-world wins
4. **Build Community**: Foster a welcoming environment
5. **Create Resources**: Provide learning materials and tools

## Philosophy: "Celebrate Good, Minimize Bad, Show Better"

We **never** shame developers. Instead:

1. **Celebrate**: Recognize what their JavaScript does well
2. **Minimize**: Gently acknowledge minor limitations
3. **Better**: Show how ReScript enhances the pattern
4. **Safety**: Explain type-level guarantees
5. **Example**: Provide concrete, encouraging examples

## Resources

### Official Documentation
- [ReScript Documentation](https://rescript-lang.org/docs)
- [ReScript Forum](https://forum.rescript-lang.org)
- [ReScript GitHub](https://github.com/rescript-lang)

### Community
- ReScript Discord
- Twitter: @rescriptlang
- ReScript Blog

## Notes for Claude

When working on this project:
- Prioritize type safety and correctness
- Suggest idiomatic ReScript patterns
- Consider JavaScript interop implications
- Help maintain clear documentation
- Encourage best practices in evangelism materials
- Focus on making ReScript accessible to newcomers
- Highlight ReScript's unique advantages over TypeScript/JavaScript
- **Use Deno, not npm/bun**
- **Use justfile, not Makefile**
- **Use ReScript, not TypeScript**
- Add SPDX license headers to new source files

## Project Philosophy

**Make ReScript Approachable**: The goal is to help developers discover and adopt ReScript by:
- Showing practical examples
- Addressing common concerns
- Demonstrating real benefits
- Providing migration paths
- Building confidence through education

---

*This document should be updated as the project evolves and new patterns emerge.*

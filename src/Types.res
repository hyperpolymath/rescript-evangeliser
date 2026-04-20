// SPDX-License-Identifier: PMPL-1.0-or-later
// Core type definitions for Nextgen Languages Evangeliser
// Philosophy: "Celebrate good, minimize bad, show better"

type viewLayer = RAW | FOLDED | GLYPHED | WYSIWYG

type difficultyLevel = Beginner | Intermediate | Advanced

type patternCategory =
  | NullSafety
  | Async
  | ErrorHandling
  | ArrayOperations
  | Conditionals
  | Destructuring
  | Defaults
  | Functional
  | Templates
  | ArrowFunctions
  | Variants
  | Modules
  | TypeSafety
  | Immutability
  | PatternMatching
  | PipeOperator
  | OopToFp
  | ClassesToRecords
  | InheritanceToComposition
  | StateMachines
  | DataModeling
  // Phase 2 — affine/linear-safety-focused categories.
  | ResourceSafety
  | Aliasing
  | Disposal

type semanticCategory =
  | Transformation
  | Safety
  | Flow
  | Structure
  | State
  | Data

type targetLang =
  | AffineScript
  | ReScript
  | Rust
  | Gleam
  | Zig

let flagshipTarget: targetLang = AffineScript

type glyph = {
  symbol: string,
  name: string,
  meaning: string,
  semanticCategory: semanticCategory,
  usageExample: string,
}

type narrative = {
  celebrate: string,
  minimize: string,
  better: string,
  safety: string,
  example: string,
}

type targetExample = {
  language: targetLang,
  code: string,
}

type pattern = {
  id: string,
  name: string,
  category: patternCategory,
  difficulty: difficultyLevel,
  jsPattern: string,
  confidence: float,
  jsExample: string,
  targets: array<targetExample>,
  narrative: narrative,
  glyphs: array<string>,
  tags: array<string>,
  relatedPatterns: array<string>,
  learningObjectives: array<string>,
  commonMistakes: array<string>,
  bestPractices: array<string>,
}

type patternMatch = {
  pattern: pattern,
  code: string,
  startLine: int,
  endLine: int,
  confidence: float,
  transformation: option<string>,
}

type analysisResult = {
  matches: array<patternMatch>,
  totalPatterns: int,
  coveragePercentage: float,
  difficulty: difficultyLevel,
  suggestedNextPatterns: array<pattern>,
  analysisTime: float,
  memoryUsed: int,
}

type rec learningProgress = {
  patternsCompleted: Set.t<string>,
  currentDifficulty: difficultyLevel,
  totalTransformations: int,
  favoritePatterns: array<string>,
  achievements: array<achievement>,
  startDate: Date.t,
  lastActive: Date.t,
}
and achievement = {
  achievementId: string,
  achievementName: string,
  description: string,
  icon: string,
  unlockedAt: option<Date.t>,
}

type extensionConfig = {
  defaultView: viewLayer,
  showNarratives: bool,
  autoDetectPatterns: bool,
  difficultyLevel: option<difficultyLevel>,
  enableTelemetry: bool,
  performanceMode: bool,
  customPatternPaths: array<string>,
}

type patternStats = {
  total: int,
  byCategory: Dict.t<int>,
  byDifficulty: Dict.t<int>,
}

let categoryToString = (category: patternCategory): string => {
  switch category {
  | NullSafety => "null-safety"
  | Async => "async"
  | ErrorHandling => "error-handling"
  | ArrayOperations => "array-operations"
  | Conditionals => "conditionals"
  | Destructuring => "destructuring"
  | Defaults => "defaults"
  | Functional => "functional"
  | Templates => "templates"
  | ArrowFunctions => "arrow-functions"
  | Variants => "variants"
  | Modules => "modules"
  | TypeSafety => "type-safety"
  | Immutability => "immutability"
  | PatternMatching => "pattern-matching"
  | PipeOperator => "pipe-operator"
  | OopToFp => "oop-to-fp"
  | ClassesToRecords => "classes-to-records"
  | InheritanceToComposition => "inheritance-to-composition"
  | StateMachines => "state-machines"
  | DataModeling => "data-modeling"
  | ResourceSafety => "resource-safety"
  | Aliasing => "aliasing"
  | Disposal => "disposal"
  }
}

let difficultyToString = (difficulty: difficultyLevel): string => {
  switch difficulty {
  | Beginner => "beginner"
  | Intermediate => "intermediate"
  | Advanced => "advanced"
  }
}

let viewLayerToString = (view: viewLayer): string => {
  switch view {
  | RAW => "RAW"
  | FOLDED => "FOLDED"
  | GLYPHED => "GLYPHED"
  | WYSIWYG => "WYSIWYG"
  }
}

let targetLangToString = (t: targetLang): string => {
  switch t {
  | AffineScript => "affinescript"
  | ReScript => "rescript"
  | Rust => "rust"
  | Gleam => "gleam"
  | Zig => "zig"
  }
}

let targetLangLabel = (t: targetLang): string => {
  switch t {
  | AffineScript => "AffineScript"
  | ReScript => "ReScript"
  | Rust => "Rust"
  | Gleam => "Gleam"
  | Zig => "Zig"
  }
}

let targetLangSyntaxTag = (t: targetLang): string => {
  switch t {
  | AffineScript => "affinescript"
  | ReScript => "rescript"
  | Rust => "rust"
  | Gleam => "gleam"
  | Zig => "zig"
  }
}

let stringToTargetLang = (s: string): option<targetLang> => {
  switch String.toLowerCase(s) {
  | "affinescript" | "affine" | "as" => Some(AffineScript)
  | "rescript" | "res" => Some(ReScript)
  | "rust" | "rs" => Some(Rust)
  | "gleam" => Some(Gleam)
  | "zig" => Some(Zig)
  | _ => None
  }
}

let patternExampleFor = (p: pattern, lang: targetLang): option<targetExample> => {
  p.targets->Array.find(t => t.language == lang)
}

let patternCodeFor = (p: pattern, lang: targetLang): string => {
  switch patternExampleFor(p, lang) {
  | Some(t) => t.code
  | None =>
    switch p.targets->Array.get(0) {
    | Some(t) => t.code
    | None => ""
    }
  }
}

let patternEffectiveTarget = (p: pattern, requested: targetLang): targetLang => {
  switch patternExampleFor(p, requested) {
  | Some(_) => requested
  | None =>
    switch p.targets->Array.get(0) {
    | Some(t) => t.language
    | None => requested
    }
  }
}

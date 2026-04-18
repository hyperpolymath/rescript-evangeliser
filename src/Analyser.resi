// SPDX-License-Identifier: PMPL-1.0-or-later
// Analyser: public interface for code analysis orchestration

// Run full analysis on JavaScript code using the built-in pattern library
let analyse: (string) => Types.analysisResult

// Run analysis with a custom set of patterns
let analyseWithPatterns: (string, array<Types.pattern>) => Types.analysisResult

// Generate a human-readable narrative summary of analysis results
let summarise: (Types.analysisResult) => string

// SPDX-License-Identifier: PMPL-1.0-or-later
// Scanner: public interface for JavaScript code pattern scanning

// Scan a block of code against a specific set of patterns
let scanCode: (string, array<Types.pattern>) => array<Types.patternMatch>

// Scan code against the full built-in pattern library
let scanAll: (string) => array<Types.patternMatch>

// Deduplicate matches by pattern ID, returning unique patterns
let uniquePatterns: (array<Types.patternMatch>) => array<Types.pattern>

// Count matches grouped by pattern category
let matchesByCategory: (array<Types.patternMatch>) => Dict.t<int>

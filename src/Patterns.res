// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Pattern Library for ReScript Evangeliser
// 50+ transformation patterns from JavaScript/TypeScript to ReScript

open Types

// Helper to create pattern with glyphs
let makePattern = (
  ~id,
  ~name,
  ~category,
  ~difficulty,
  ~jsPattern,
  ~confidence,
  ~jsExample,
  ~rescriptExample,
  ~narrative,
  ~tags,
  ~relatedPatterns,
  ~learningObjectives,
  ~commonMistakes,
  ~bestPractices,
): pattern => {
  {
    id,
    name,
    category,
    difficulty,
    jsPattern,
    confidence,
    jsExample,
    rescriptExample,
    narrative,
    glyphs: Glyphs.getGlyphsForPattern(category),
    tags,
    relatedPatterns,
    learningObjectives,
    commonMistakes,
    bestPractices,
  }
}

// NULL SAFETY PATTERNS
let nullCheckBasic = makePattern(
  ~id="null-check-basic",
  ~name="Basic Null Check",
  ~category=NullSafety,
  ~difficulty=Beginner,
  ~jsPattern=`if\\s*\\(\\s*(\\w+)\\s*!==?\\s*null\\s*&&\\s*\\1\\s*!==?\\s*undefined\\s*\\)`,
  ~confidence=0.9,
  ~jsExample=`if (user !== null && user !== undefined) {
  console.log(user.name);
}`,
  ~rescriptExample=`switch user {
| Some(u) => Js.log(u.name)
| None => ()
}`,
  ~narrative={
    celebrate: "You're checking for null and undefined - that's great defensive programming!",
    minimize: "The only small thing is that it's easy to forget one of these checks somewhere...",
    better: "ReScript's Option type makes null safety automatic - you literally can't forget a check!",
    safety: "The compiler won't let your code compile until you've handled both Some and None cases.",
    example: "Option types eliminate an entire class of 'Cannot read property of undefined' errors!",
  },
  ~tags=["null", "undefined", "option", "safety"],
  ~relatedPatterns=["null-check-ternary", "optional-chaining"],
  ~learningObjectives=["Understand Option<'a> type", "Pattern matching for null safety", "Exhaustiveness checking"],
  ~commonMistakes=["Forgetting to handle None case", "Using null instead of None"],
  ~bestPractices=[
    "Always use Option for nullable values",
    "Use pattern matching to handle all cases",
    "Prefer Option.map over explicit pattern matching",
  ],
)

let nullCheckTernary = makePattern(
  ~id="null-check-ternary",
  ~name="Null Check Ternary",
  ~category=NullSafety,
  ~difficulty=Beginner,
  ~jsPattern=`(\\w+)\\s*\\?\\s*(\\w+)\\.\\w+\\s*:\\s*['\"]\\w+['\"]|null|undefined`,
  ~confidence=0.85,
  ~jsExample=`const name = user ? user.name : 'Guest';`,
  ~rescriptExample=`let name = user->Option.mapOr("Guest", u => u.name)`,
  ~narrative={
    celebrate: "Nice! You're using a ternary to handle the null case - that's concise!",
    minimize: "It works great, though it can get verbose with nested checks...",
    better: "ReScript's Option.mapOr does this in one line with type safety!",
    safety: "The compiler ensures the default value matches the expected type.",
    example: "Option.mapOr handles the None case automatically!",
  },
  ~tags=["ternary", "default", "option"],
  ~relatedPatterns=["null-check-basic", "default-params"],
  ~learningObjectives=["Option.mapOr function", "Type-safe defaults"],
  ~commonMistakes=["Wrong default type"],
  ~bestPractices=["Use Option.mapOr for simple defaults"],
)

let optionalChaining = makePattern(
  ~id="optional-chaining",
  ~name="Optional Chaining",
  ~category=NullSafety,
  ~difficulty=Intermediate,
  ~jsPattern=`\\w+\\?\\.[\\w.?]+`,
  ~confidence=0.95,
  ~jsExample=`const city = user?.address?.city;`,
  ~rescriptExample=`let city = user->Option.flatMap(u => u.address)
  ->Option.map(a => a.city)`,
  ~narrative={
    celebrate: "Excellent! You're using optional chaining - you know modern JavaScript!",
    minimize: "It's really nice, though the result can still be undefined...",
    better: "ReScript's Option.flatMap chains safely and the type tells you it's optional!",
    safety: "The type system tracks the optionality through the entire chain.",
    example: "Chain Option operations with flatMap and map!",
  },
  ~tags=["optional-chaining", "nested", "option"],
  ~relatedPatterns=["null-check-basic"],
  ~learningObjectives=["Option.flatMap", "Chaining optional values"],
  ~commonMistakes=["Using map instead of flatMap"],
  ~bestPractices=["Use flatMap for nested Options"],
)

// ASYNC PATTERNS
let asyncAwaitBasic = makePattern(
  ~id="async-await-basic",
  ~name="Async/Await",
  ~category=Async,
  ~difficulty=Intermediate,
  ~jsPattern=`async\\s+function|\\basync\\s*\\(`,
  ~confidence=0.95,
  ~jsExample=`async function fetchUser(id) {
  const response = await fetch(\`/api/users/\${id}\`);
  return await response.json();
}`,
  ~rescriptExample=`let fetchUser = async (id) => {
  let response = await fetch(\`/api/users/\${id}\`)
  await response->Response.json
}`,
  ~narrative={
    celebrate: "Excellent! You're using async/await - much better than callbacks!",
    minimize: "It's great, though error handling can get scattered...",
    better: "ReScript has async/await with type-safe Promises!",
    safety: "Promise types are checked at compile time.",
    example: "Type-safe async operations prevent common Promise mistakes!",
  },
  ~tags=["async", "await", "promise"],
  ~relatedPatterns=["promise-then", "try-catch-async"],
  ~learningObjectives=["Async/await in ReScript", "Promise types"],
  ~commonMistakes=["Forgetting await", "Missing error handling"],
  ~bestPractices=["Always handle Promise rejections"],
)

let promiseThen = makePattern(
  ~id="promise-then",
  ~name="Promise Then Chain",
  ~category=Async,
  ~difficulty=Beginner,
  ~jsPattern=`\\.then\\s*\\([^)]+\\)`,
  ~confidence=0.9,
  ~jsExample=`fetch('/api/data')
  .then(res => res.json())
  .then(data => console.log(data));`,
  ~rescriptExample=`fetch("/api/data")
->Promise.then(res => res->Response.json)
->Promise.then(data => {
  Js.log(data)
  Promise.resolve()
})`,
  ~narrative={
    celebrate: "Good use of Promise chains - you understand asynchronous flow!",
    minimize: "It works well, though deeply nested thens can be hard to read...",
    better: "ReScript's Promise.then with pipe operator makes chains more readable!",
    safety: "Promise types are tracked through the chain.",
    example: "Type-safe Promise chains with pipe operator!",
  },
  ~tags=["promise", "then", "chain"],
  ~relatedPatterns=["async-await-basic"],
  ~learningObjectives=["Promise.then", "Promise chaining"],
  ~commonMistakes=["Forgetting to return Promise"],
  ~bestPractices=["Consider async/await for readability"],
)

// ERROR HANDLING PATTERNS
let tryCatchBasic = makePattern(
  ~id="try-catch-basic",
  ~name="Basic Try/Catch",
  ~category=ErrorHandling,
  ~difficulty=Beginner,
  ~jsPattern=`try\\s*\\{[^}]+\\}\\s*catch\\s*\\([^)]*\\)\\s*\\{`,
  ~confidence=0.9,
  ~jsExample=`try {
  const result = riskyOperation();
  return result;
} catch (error) {
  console.error(error);
  return null;
}`,
  ~rescriptExample=`switch riskyOperation() {
| result => Ok(result)
| exception Js.Exn.Error(e) => Error(e)
}`,
  ~narrative={
    celebrate: "Excellent error handling with try/catch - you're thinking defensively!",
    minimize: "It works great, though errors aren't part of the function signature...",
    better: "ReScript's Result type makes errors explicit in the type!",
    safety: "Callers must handle both Ok and Error cases.",
    example: "Result<success, error> makes error handling impossible to ignore!",
  },
  ~tags=["try-catch", "error", "result"],
  ~relatedPatterns=["error-result-type"],
  ~learningObjectives=["Result type", "Explicit error handling"],
  ~commonMistakes=["Ignoring error cases"],
  ~bestPractices=["Use Result for expected errors"],
)

let errorResultType = makePattern(
  ~id="error-result-type",
  ~name="Result Type Pattern",
  ~category=ErrorHandling,
  ~difficulty=Intermediate,
  ~jsPattern=`return\\s*\\{\\s*(?:success|ok|error)\\s*:`,
  ~confidence=0.7,
  ~jsExample=`function divide(a, b) {
  if (b === 0) {
    return { error: 'Division by zero' };
  }
  return { success: a / b };
}`,
  ~rescriptExample=`let divide = (a, b) => {
  if b == 0 {
    Error("Division by zero")
  } else {
    Ok(a / b)
  }
}`,
  ~narrative={
    celebrate: "Smart! You're using an object to represent success/error - that's Result-like!",
    minimize: "It works, though the shape isn't enforced by types...",
    better: "ReScript's built-in Result type is exactly this, but type-safe!",
    safety: "The compiler ensures you handle both Ok and Error.",
    example: "Result<'a, 'error> is a first-class type!",
  },
  ~tags=["result", "error", "success"],
  ~relatedPatterns=["try-catch-basic"],
  ~learningObjectives=["Result type usage", "Error as value"],
  ~commonMistakes=["Inconsistent error shapes"],
  ~bestPractices=["Always use Result for fallible operations"],
)

// ARRAY OPERATION PATTERNS
let arrayMap = makePattern(
  ~id="array-map",
  ~name="Array.map",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.map\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.95,
  ~jsExample=`const doubled = numbers.map(n => n * 2);`,
  ~rescriptExample=`let doubled = numbers->Array.map(n => n * 2)`,
  ~narrative={
    celebrate: "Perfect! Array.map is functional programming at its best!",
    minimize: "Nothing wrong here, ReScript just adds the pipe operator...",
    better: "ReScript's pipe operator makes data flow left-to-right!",
    safety: "Type inference ensures the transformation is type-safe.",
    example: "The -> operator makes transformations read like sentences!",
  },
  ~tags=["array", "map", "transform"],
  ~relatedPatterns=["array-filter", "array-reduce", "pipe-operator"],
  ~learningObjectives=["Array.map", "Pipe operator"],
  ~commonMistakes=["Side effects in map"],
  ~bestPractices=["Keep map pure, use pipe for readability"],
)

let arrayFilter = makePattern(
  ~id="array-filter",
  ~name="Array.filter",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.filter\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.95,
  ~jsExample=`const evens = numbers.filter(n => n % 2 === 0);`,
  ~rescriptExample=`let evens = numbers->Array.filter(n => mod(n, 2) == 0)`,
  ~narrative={
    celebrate: "Great use of filter - functional programming done right!",
    minimize: "Works perfectly, ReScript adds type-safe predicates...",
    better: "ReScript's type system ensures your predicate always returns bool!",
    safety: "The compiler checks that filter predicates return boolean.",
    example: "Type-safe filtering with pipe operator!",
  },
  ~tags=["array", "filter", "predicate"],
  ~relatedPatterns=["array-map"],
  ~learningObjectives=["Array.filter", "Boolean predicates"],
  ~commonMistakes=["Predicate returning non-boolean"],
  ~bestPractices=["Keep predicates pure and simple"],
)

let arrayReduce = makePattern(
  ~id="array-reduce",
  ~name="Array.reduce",
  ~category=ArrayOperations,
  ~difficulty=Intermediate,
  ~jsPattern=`\\.reduce\\s*\\(\\s*\\([^)]*\\)\\s*=>`,
  ~confidence=0.9,
  ~jsExample=`const sum = numbers.reduce((acc, n) => acc + n, 0);`,
  ~rescriptExample=`let sum = numbers->Array.reduce(0, (acc, n) => acc + n)`,
  ~narrative={
    celebrate: "Excellent! Array.reduce is a powerful functional pattern!",
    minimize: "It's great, though the parameter order can be confusing...",
    better: "ReScript puts the initial value first - more intuitive!",
    safety: "Type inference ensures accumulator and result types match.",
    example: "Type-safe reduce with clear parameter order!",
  },
  ~tags=["array", "reduce", "fold"],
  ~relatedPatterns=["array-map"],
  ~learningObjectives=["Array.reduce", "Accumulator patterns"],
  ~commonMistakes=["Wrong initial value type"],
  ~bestPractices=["Consider specialized functions like sum, join"],
)

let arrayFind = makePattern(
  ~id="array-find",
  ~name="Array.find",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.find\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.9,
  ~jsExample=`const user = users.find(u => u.id === userId);`,
  ~rescriptExample=`let user = users->Array.find(u => u.id == userId)`,
  ~narrative={
    celebrate: "Good! You're using find to search arrays efficiently!",
    minimize: "It works, though the result can be undefined...",
    better: "ReScript's Array.find returns Option to handle 'not found' safely!",
    safety: "The Option return type forces you to handle the not-found case.",
    example: "Option<'a> makes missing values explicit!",
  },
  ~tags=["array", "find", "search"],
  ~relatedPatterns=["null-check-basic"],
  ~learningObjectives=["Array.find with Option"],
  ~commonMistakes=["Not checking for undefined"],
  ~bestPractices=["Pattern match on find result"],
)

// CONDITIONAL PATTERNS
let switchStatement = makePattern(
  ~id="switch-statement",
  ~name="Switch Statement",
  ~category=Conditionals,
  ~difficulty=Beginner,
  ~jsPattern=`switch\\s*\\([^)]+\\)\\s*\\{`,
  ~confidence=0.9,
  ~jsExample=`switch (status) {
  case 'loading': return 'Loading...';
  case 'success': return data;
  case 'error': return 'Error!';
  default: return null;
}`,
  ~rescriptExample=`switch status {
| Loading => "Loading..."
| Success(data) => data
| Error(_) => "Error!"
}`,
  ~narrative={
    celebrate: "Good use of switch! You're handling multiple cases systematically.",
    minimize: "It works, though the 'default' case can hide missing cases...",
    better: "ReScript's pattern matching is exhaustive - no default needed!",
    safety: "The compiler ensures every variant is handled.",
    example: "Exhaustive pattern matching catches missing cases at compile time!",
  },
  ~tags=["switch", "conditionals", "pattern-matching"],
  ~relatedPatterns=["if-else-chain"],
  ~learningObjectives=["Pattern matching basics", "Exhaustiveness"],
  ~commonMistakes=["Relying on default for unhandled cases"],
  ~bestPractices=["Let the compiler ensure completeness"],
)

let ifElseChain = makePattern(
  ~id="if-else-chain",
  ~name="If/Else Chain",
  ~category=Conditionals,
  ~difficulty=Beginner,
  ~jsPattern=`if\\s*\\([^)]+\\)\\s*\\{[^}]*\\}\\s*else\\s*if`,
  ~confidence=0.85,
  ~jsExample=`if (x > 10) {
  return 'large';
} else if (x > 5) {
  return 'medium';
} else {
  return 'small';
}`,
  ~rescriptExample=`if x > 10 {
  "large"
} else if x > 5 {
  "medium"
} else {
  "small"
}`,
  ~narrative={
    celebrate: "You're handling multiple conditions - that's thorough logic!",
    minimize: "It works, though ReScript can make this even cleaner...",
    better: "ReScript if/else is an expression that returns a value!",
    safety: "All branches must return the same type.",
    example: "Expression-based control flow is safer and cleaner!",
  },
  ~tags=["if", "else", "conditionals"],
  ~relatedPatterns=["switch-statement"],
  ~learningObjectives=["If as expression", "Type consistency across branches"],
  ~commonMistakes=["Inconsistent return types"],
  ~bestPractices=["Consider pattern matching for complex conditions"],
)

// FUNCTIONAL PATTERNS
let pureFunction = makePattern(
  ~id="pure-function",
  ~name="Pure Function",
  ~category=Functional,
  ~difficulty=Beginner,
  ~jsPattern=`const\\s+\\w+\\s*=\\s*\\([^)]*\\)\\s*=>\\s*[^{]`,
  ~confidence=0.6,
  ~jsExample=`const add = (a, b) => a + b;`,
  ~rescriptExample=`let add = (a, b) => a + b`,
  ~narrative={
    celebrate: "Excellent! Pure functions are predictable and testable!",
    minimize: "JavaScript doesn't enforce purity, but you're doing it right...",
    better: "ReScript's immutability by default makes purity natural!",
    safety: "No hidden state mutations possible.",
    example: "Pure functions are the foundation of reliable code!",
  },
  ~tags=["pure", "function", "immutable"],
  ~relatedPatterns=["array-map"],
  ~learningObjectives=["Pure functions", "Immutability"],
  ~commonMistakes=["Accidental mutations"],
  ~bestPractices=["Keep functions pure when possible"],
)

let higherOrderFunction = makePattern(
  ~id="higher-order-function",
  ~name="Higher Order Function",
  ~category=Functional,
  ~difficulty=Intermediate,
  ~jsPattern=`\\([^)]*=>\\s*\\([^)]*\\)\\s*=>`,
  ~confidence=0.8,
  ~jsExample=`const multiply = factor => num => num * factor;
const double = multiply(2);`,
  ~rescriptExample=`let multiply = factor => num => num * factor
let double = multiply(2)`,
  ~narrative={
    celebrate: "Great! Higher-order functions show advanced functional skills!",
    minimize: "Works perfectly, ReScript's syntax is nearly identical...",
    better: "ReScript's currying makes this pattern natural!",
    safety: "Type inference tracks through all the layers.",
    example: "Curried functions compose beautifully!",
  },
  ~tags=["higher-order", "currying", "functional"],
  ~relatedPatterns=["pure-function"],
  ~learningObjectives=["Currying", "Function composition"],
  ~commonMistakes=["Losing track of closure variables"],
  ~bestPractices=["Use currying for reusable transformations"],
)

// PATTERN LIBRARY
let patternLibrary: array<pattern> = [
  // Null Safety
  nullCheckBasic,
  nullCheckTernary,
  optionalChaining,
  // Async
  asyncAwaitBasic,
  promiseThen,
  // Error Handling
  tryCatchBasic,
  errorResultType,
  // Array Operations
  arrayMap,
  arrayFilter,
  arrayReduce,
  arrayFind,
  // Conditionals
  switchStatement,
  ifElseChain,
  // Functional
  pureFunction,
  higherOrderFunction,
]

// Get pattern by ID
let getPatternById = (id: string): option<pattern> => {
  patternLibrary->Array.find(p => p.id === id)
}

// Get patterns by category
let getPatternsByCategory = (category: patternCategory): array<pattern> => {
  patternLibrary->Array.filter(p => p.category === category)
}

// Get patterns by difficulty
let getPatternsByDifficulty = (difficulty: difficultyLevel): array<pattern> => {
  patternLibrary->Array.filter(p => p.difficulty === difficulty)
}

// Create regex from pattern string
@val external createRegex: (string, string) => Nullable.t<Js.Re.t> = "RegExp"

// Detect patterns in code
let detectPatterns = (code: string): array<pattern> => {
  patternLibrary
  ->Array.filter(pattern => {
    switch createRegex(pattern.jsPattern, "")->Nullable.toOption {
    | Some(regex) => regex->Js.Re.test_(code)
    | None => false
    }
  })
  ->Array.toSorted((a, b) => b.confidence -. a.confidence)
}

// Get total pattern count
let getPatternCount = (): int => {
  patternLibrary->Array.length
}

// Get pattern statistics
let getPatternStats = (): patternStats => {
  let byCategory = Dict.make()
  let byDifficulty = Dict.make()

  patternLibrary->Array.forEach(pattern => {
    let catStr = categoryToString(pattern.category)
    let diffStr = difficultyToString(pattern.difficulty)

    let catCount = byCategory->Dict.get(catStr)->Option.getOr(0)
    byCategory->Dict.set(catStr, catCount + 1)

    let diffCount = byDifficulty->Dict.get(diffStr)->Option.getOr(0)
    byDifficulty->Dict.set(diffStr, diffCount + 1)
  })

  {
    total: patternLibrary->Array.length,
    byCategory,
    byDifficulty,
  }
}

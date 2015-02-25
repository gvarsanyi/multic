Development notes
==================

There are some missing and/or incosistent features of the compileres.

# Tests
Tests will catch loss of existing functionalities, and should catch most of the API breaking changes too.
    make test

# Missing and problematic features

Watch out for these issues when changing processor versions!

## jade (jade->html compiler)
- Includes: files are not exposed. Patch is applied to get them
- Errors: no column indication
- Warnings:
  - pushed to STDERR, *multic* takes over console.warn() for compilation time, and parses string - this is really bad.
  - no column indication

## ng-html2js (html->ng-js-module compiler)
- Errors: no errors (does not even catch invalid HTML)

## clean-css (css minifier)
- Errors/Warnings
  - seems to produce only warnings but they seem to be errors actually (now channelled to res.errors[])
  - many CSS syntax errors are not cought (they are either kept or skipped)
  - no line nor column indication

## jshint vs coffeelint
- *coffeelint* does not support arbitrary max_line_length, only 80
- consequent indentation checks are not supported by *jshint*

# Inconsistencies

## Linting
### Jade
- Should be sorted out to be an external library
- Patches the compiler to expose nodes to parse them
- Some of the rules are not finished yet (compared to htmllint), see `TODO` remarks in code

### Coffee-JS/ES6
- Some of the rules are not properly matching yet, see `TODO` remarks in code

### SASS, CSS
- No linting yet

## Error objects
### No line numbers in errors (thus no code snippets)
- clean-css (minifier)

### Has line numbers but no column information
- jade errors+warnings (for both compiler and linter)

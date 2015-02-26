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

# Inconsistencies

## Linting
### jade
- Should be sorted out to be an external library
- Patches the compiler to expose nodes to parse them
- Some of the rules are not finished yet (compared to htmllint), see `TODO` remarks in code

### jshint
- consequent indentation checks are not supported by *jshint*

### coffee vs jshint
- Some of the rules are not properly matching yet, see `TODO` remarks in code

### SASS
- No dedicated linting

## Error objects
### Has line numbers but no column information
- jade errors+warnings (for both compiler and linter)

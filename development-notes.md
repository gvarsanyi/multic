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

## minify (html minifier)
- Errors: no errors (does not even catch invalid HTML)


# Inconsistencies

## No warnings
Only a few compilers/minifiers would produce warning level messages. The ones that do NOT feature warnings:
- Compilers:
  - coffee
  - es6
  - ng-html2js
- Minifiers:
  - clean-css (produces warnings that are errors actually)
  - minify
  - uglify-js

## No errors
A few processors just won't fail when needed:
- ng-html2js (compiler)
- clean-css (minifier) will provide some errors
- minify (minifier)

### Has errors but no line numbers (thus no code snippets)
- clean-css (minifier)

### Has errors and line numbers but no column information
- jade errors
- jade warnings


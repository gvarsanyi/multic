multic
==========

node.js compiler and minifier API for various web sources: jade, html, sass/scss, css, coffee-script, es6/babel, javascript/es5, html2js

# Install for your app
    cd /path/to/your/app
    npm install multic --save

# Usage

## Pattern
    var multic = require('multic');

    multic(source|path[, options])[.file].coffee|css|es6|html|jade|sass[.css|html|js][.min](callback);

## Examples
### Concept
#### JavaScript string minification
    multic(script, {file: 'my/file/name.js'}).js.min( function (err, res) {}) ;
#### Jade file->HTML compilation
    multic('my/jade/file.jade').file.jade.html( function (err, res) {} );
#### Compile SASS file to CSS + minify
    multic('my/sass/file.scss').file.sass.css.min( function (err, res) {} );
#### Jade to Angular module JavaScript
    multic('my/sass/file.scss').file.sass.css.min( function (err, res) {
      if (err) {
        console.error(err);
      } else {
        console.log('source:', res.source);
        console.log('compiled:', res.compiled);
        console.log('minified:', res.minified);
      }
    } );
#### Lint only (syntax errors and warnings, no processing)
    multic('my/js/file.js').file.js( function (err, res) { }

### Callback signitures
- __err__: null or Error instance (same as the first item in `res.errors`)
- __res__: response object
#### Response object properties
- __source__:
  - content: source code
  - type: string
  - optional: only exists if file is read
- __compiled__:
  - content: compiled, unminified code
  - type: string
  - optional: only exists if compilation was requested
- __minified__:
  - content: minified code
  - type: string
  - optional: only exists if minification was requested
- __includes__
  - content: included files for jade and sass files with includes/import
  - type: Array object
  - default value: empty Array
  - always created
- __errors__: Array of errors (always exists)
  - content: errors in consistent Error objects (see below)
  - type: Array object
  - default value: empty Array
  - always created
- __warnings__:
  - content: warnings in consistent Error objects (see below)
  - type: Array object
  - default value: empty Array
  - always created

## Consequent Errors and Warnings
Parsing errors from different kinds of compilers can be tricky. They have inconsistant error (although at times similar) error and warning messages.

Jade for example (as of v1.9.2) would produce propriatery warnings on STDERR output even when called from the API.

*multic* attempts to provide a unified interface for all errors and warnings. You get these properties on the errors/warnings:
- __message__: (*string*) literal description of the error/warning
- __title__: (*string* or *null*) short description of the error/warning
- __file__: (*string* or *null*) file path of error
- __line__: (*number* or *null*) indication of error/warning line (0-based index, i.e. first line is line 0)
- __column__: (*number* or *null*) indication of error/warning column in line (0-based index, i.e. first column is column 0)
- __sourceLines__: (*object* or *null*) a snippet of the source code around the error/warning. Keys are line numbers, values are the lines (without the \n character at the end). 11 lines (error/warning line + 5 previous + 5 following lines) or less (when the line is near the start or end of file).

In JSON format:
    {
      "title": "[coffeescript_error] Error",
      "message": "error: unexpected <",
      "file": "src/test.coffee",
      "line": 2,
      "column": 6,
      "sourceLines": {
        "0": "x = (a) ->",
        "1": "  a + 1",
        "2": "  x = <-",
        "3": ""
      }
    }

## Options
### Add file path when compiling from string
    {file: '*file_path*'}
This is useful for error messages and to define include path start point for jade and sass

### Optional lint rules
#### Enabled by default
You may turn these rules off by passing `false` as value:
- All sources
  - file_end_newline
  - indentation *(not implemented yet for: css, jade, sass)*
  - no_line_end_whitespace
  - no_tabs *(not implemented yet for: js/es6, css, jade, sass)*
- Coffee + JS/ES6 + Jade + HTML
  - quote_consistency *(not yet implemented for: jade)*
- Coffee + JS/ES6 + SASS + CSS
  - braces_spacing *(not implemented yet for: js/es6, css, sass)*
- Coffee + JS/ES6
  - camel_case_classes
  - colon_assignment_spacing *(not implemented yet for: js/es6)*
  - no_arguments_caller_or_callee *(not implemented yet for: coffee)*
  - no_interpolation_in_single_quotes *(not implemented yet for: js/es6)*
  - no_non_breaking_space *(not implemented yet for: coffee)*
  - no_throwing_strings *(not implemented yet for: js/es6)*
  - no_unnecessary_brackets *(not implemented yet for: coffee)*
  - space_operators *(not implemented yet for: js/es6)*
  - spacing_after_comma *(not implemented yet for: js/es6)*
  - typeof_value *(not implemented yet for: coffee)*
- Coffee only
  - arrow_spacing
  - no_backticks
  - no_empty_param_list
  - no_implicit_braces
  - no_trailing_semicolons
  - no_unnecessary_fat_arrows
  - prefer_english_operators
- JS/ES6 only
  - no_type_unsafe_comparison
  - wrap_immediately_called_function
- Jade only
  - no_comma_separated_attributes *(not yet implemented)*
- SASS + CSS
  - no_id_selectors *(not yet implemented for: sass)*
  - no_important_hack *(not yet implemented for: sass)*
  - no_universal_selectors *(not yet implemented for: sass)*
  - no_unqualified_attribute_selectors *(not yet implemented for: sass)*
- CSS only
  - no_css_import

#### Dsiabled by default
You may turn these rules on by passing `true` as value:
- All sources
  - max_line_length
- Coffee + JS/ES6
  - camel_case_variables *(not implemented yet for: coffee)*
  - constructor_parentheses_required *(not implemented yet for: js/es6)*
  - no_comma_operator *(not implemented yet for: coffee)*
  - no_plusplus
- JS/ES6 only
  - no_expression_looking_assignment
  - no_multiline_string
- Jade + HTML
  - no_implicit_attribute_value *(not yet implemented for: jade)*
- SASS + CSS
  - no_outline_disabling *(not yet implemented for: sass)*
  - no_qualified_headings *(not yet implemented for: sass)*
  - shorthand_property_required *(not yet implemented for: sass)*
  - unique_headings *(not yet implemented for: sass)*

# Featured processors
## Compilers
- coffee -> js: [coffee-script](https://www.npmjs.com/package/coffee-script)
- es6 -> js: [babel](https://www.npmjs.com/package/babel) (renamed from *6to5*)
- jade -> html: [jade](https://www.npmjs.com/package/jade)
- scss -> css [node-sass](https://www.npmjs.com/package/node-sass)
- html -> Angular JS module: [AngularJS module](https://www.npmjs.com/package/ng-html2js)

## Minifiers
Optionally *multic* offers minification processes with efficient but fail-safe configurations for these outputs:
- html: [html-minifier](https://www.npmjs.com/package/html-minifier)
- javascript: [uglify-js](https://www.npmjs.com/package/uglify-js)
- css: [clean-css](https://www.npmjs.com/package/clean-css)

## Linters
*multic* always parses the provided source to catch syntax and other errors.

Also it will generate warnings about things that may work you probably want to change as per best practices.
- generic lints (for EOL, EOF etc rules)
- coffee: [coffee-lint](https://www.npmjs.com/package/jshint)
- css: [csslint](https://www.npmjs.com/package/csslint)
- html: [htmllint](https://www.npmjs.com/package/htmllint)
- jade: a combination of the compiler warnings and a jade-lint plugin
- js & es6: [jshint](https://www.npmjs.com/package/jshint)

# Coming soon (TODO)
- Output to file
- Missing lint rule implementations, added descriptions and links for rules

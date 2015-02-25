multic
==========

node.js compiler and minifier API for various web sources: jade, html, sass/scss, css, coffee-script, es6/6to5, javascript/es5, html2js

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

## Options
### Add file path when compiling from string
    file: *filepath_string*useful for
This is useful for error messages and to define include path start point for jade and sass
### Turn linting off
    {lint: false}
### Enforce 80 characters line length
    {maxLength80: true}

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

# Featured compilers
- [coffee](https://www.npmjs.com/package/coffee-script) -> js
- [es6](https://www.npmjs.com/package/6to5) -> js
- [jade](https://www.npmjs.com/package/jade) -> html
- [sass/scss](https://www.npmjs.com/package/node-sass) -> css
- html -> [AngularJS module](https://www.npmjs.com/package/ng-html2js) (js)
- [jade](https://www.npmjs.com/package/jade) -> html -> [AngularJS module](https://www.npmjs.com/package/ng-html2js) (js)

## Minifiers
- html: [html-minifier](https://www.npmjs.com/package/html-minifier)
- javascript: [uglify-js](https://www.npmjs.com/package/uglify-js)
- css: [clean-css](https://www.npmjs.com/package/clean-css)

## Linters
- coffee: [coffee-lint](https://www.npmjs.com/package/jshint)
- html: [htmllint](https://www.npmjs.com/package/htmllint)
- js & es6: [jshint](https://www.npmjs.com/package/jshint)

# Coming soon (TODO)
- Output to file
- Lint only
- Some SASS and CSS

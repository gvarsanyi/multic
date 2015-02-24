multic
==========

node.js compiler and minifier API for various web sources: jade, html, sass/scss, css, coffee-script, es6/6to5, javascript/es5, html2js

# Install for your app
    cd /path/to/your/app
    npm install multic --save

# Usage

## Pattern
    multic._sourceType_(source)[._targetType_].min([options], callback)
### Callback signitures
- __err__: null or Error instance
- __res__: object
#### Response object properties
- __compiled__: compiled, unminified source
- __minified__: minified source
- __includes__: Array of included files (for jade and sass)
- __errors__: Array of errors
- __warnings__: Array of warnings

## Examples
### Concept
#### Minification only
    multic.js(script).min( function (err, res) {}) ;
#### Compilation only
    multic.jade(script).html( function (err, res) {} );
#### Compile + minify
    multic.sass(script).css.min( function (err, res) {} );

### Full code example
    var multic = require('multic');

    multic.coffee(coffee_source).js.min(function (err, res) {
      if (err) {
        console.error(err);
      } else {
        console.log(res.minified);
      }
    });

    // jade to pretty html
    multic.jade(jade_source).html(function (err, res) {
      if (err) {
        console.error(err);
      } else {
        console.log('Compiled source:', res.compiled);
      }
    });

    // jade to angular module javascript
    multic.jade(jade_source).js(function (err, res) {
      if (err) {
        console.error(err);
      } else {
        console.log(res.compiled);
      }
    });

# Consequent errors and warnings
Parsing errors from different kinds of compilers can be tricky. They have inconsistant error (although at times similar) error and warning messages.

Jade for example (as of v1.9.2) would produce propriatery warnings on STDERR output even when called from the API.

*multic* attempts to provide a unified interface for all errors and warnings. You get these properties on the errors/warnings:
- __message__: (*string*) literal description of the error/warning
- __title__: (*string* or *null*) short description of the error/warning
- __file__: (*string* or *null*) file path of error
- __line__: (*number* or *null*) indication of error/warning line (0-based index, i.e. first line is line 0)
- __column__: (*number* or *null*) indication of error/warning column in line (0-based index, i.e. first column is column 0)
- __sourceLines__: (*object* or *null*) a snippet of the source code around the error/warning. Keys are line numbers, values are the lines (without the \n character at the end). 11 lines (error/warning line + 5 previous + 5 following lines) or less (when the line is near the start or end of file).


## Featured compilers
- [coffee](https://www.npmjs.com/package/coffee-script) -> js
- [es6](https://www.npmjs.com/package/6to5) -> js
- [jade](https://www.npmjs.com/package/jade) -> html
- [sass/scss](https://www.npmjs.com/package/node-sass) -> css
- html -> [AngularJS module](https://www.npmjs.com/package/ng-html2js) (js)
- [jade](https://www.npmjs.com/package/jade) -> html -> [AngularJS module](https://www.npmjs.com/package/ng-html2js) (js)

## Minifiers
- html: [minimize](https://www.npmjs.com/package/minimize)
- javascript: [uglify-js](https://www.npmjs.com/package/uglify-js)
- css: [clean-css](https://www.npmjs.com/package/clean-css)

## Coming soon (TODO)
- Compiling from file
- Complete coverage for unified errors and warnings
- Lint support (generate warnings)
- Standard warnings and errors for minifiers

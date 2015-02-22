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

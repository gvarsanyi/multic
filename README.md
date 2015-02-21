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
- __compiled__: compiled, unminified source
- __minified__: minified source
- __include_files__: null or Array of included files (for jade and sass)
- __warnings__: null or Array of warnings

#### Minification only
    multic.js(script).min( function (err, minified[, warnings]) {}) ;
#### Compilation only
    multic.jade(script).html( function (err, compiled, include_files, warnings) {} );
#### Compile + minify
    multic.sass(script).css.min( function (err, compiled, minified, include_files, warnings) {} );

## Examples
## CoffeeScript to minified JavaScript
    var multic = require('multic');

    multic.coffee(coffee_source).js.min(function (err, compiled, minified, include_files, warnings) {
      if (err) {
        console.error(err);
      } else {
        console.log(minified);
      }
    });

    // jade to pretty html
    multic.coffee(jade_source).html(function (err, compiled, include_files, warnings) {
      if (err) {
        console.error(err);
      } else {
        console.log('Compiled source:', compiled);
      }
    });

    // jade to pretty html
    multic.coffee(jade_source).html(function (err, compiled, include_files, warnings) {
      if (err) {
        console.error(err);
      } else {
        console.log('Compiled source:', compiled);
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

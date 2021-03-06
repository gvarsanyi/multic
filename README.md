Compile, Minify, Lint
======================

*multic* attempts to fix the compilation, minification, linting inconsistancies by providing:
- simple, consistent API
- consistent error and warning level objects
- sane defaults for errors and warnings
- converged lint rules

# Supported sources
- [Jade](http://jade-lang.com/)
- HTML
- [LESS](http://lesscss.org/)
- [SASS](http://sass-lang.com/) via [libsass](https://github.com/sass/libsass) / [node-sass](https://www.npmjs.com/package/node-sass)
- CSS
- [CoffeeScript](http://coffeescript.org/)
- ECMAScript6 via [Babel](http://babeljs.io/) (ex: 6to5)
- JavaScript
- [Angular](https://angularjs.org/) module scripts from HTML/JADE templates via [ng-html2js](https://www.npmjs.com/package/ng-html2js)


# Install for your app
    cd /path/to/your/app
    npm install multic --save

# Usage

## Pattern
    var multic = require('multic');

    // with promise
    var promise = multic(source|path[, options])[.file].coffee|css|es6|html|jade|less|sass[.css|html|js][.min][.write]([target_file]);

    // with callback function(err, res) {}
    multic(source|path[, options])[.file].coffee|css|es6|html|jade|less|sass[.css|html|js][.min](callback);

    // write to output file with callback
    multic(source|path[, options])[.file].coffee|css|es6|html|jade|less|sass[.css|html|js][.min].write(target_file, callback);

## Examples

### JavaScript string minification
    var promise = multic(script, {file: 'my/file/name.js'}).js.min();

### Jade file->HTML compilation
    var promise = multic('my/jade/file.jade').file.jade.html();

### Compile LESS file to CSS + write to output file
    var promise = multic('my/sass/file.scss').file.less.css.write('my/deployment/dist.css');

### Compile SASS file to CSS + minify + write to output file
    var promise = multic('my/sass/file.scss').file.sass.css.min.write('my/deployment/dist.min.css');

### Lint only (syntax errors and warnings, no processing)
    var promise = multic('my/js/file.js').file.js()

### Promise response
    var promise = multic('my/sass/file.scss').file.sass.css.min();
    promise.then( function (res) {
      console.log('source:', res.source);
      console.log('compiled:', res.compiled);
      console.log('minified:', res.minified);
    }, function (err) {
      console.error('error:', err);
      console.error('response object is also available:', err.res);
    } );


## Callback signiture
- __err__: null or Error instance (same as the first item in `res.errors`)
- __res__: response object

## Response object properties
    {
      source:   '#id1.class1\n  h1 Hello\n  include templates/_hi\n',
      compiled: '<div id='id1' class='class1'>\n  <h1>Hello</h1>\n  <h2>Hi</h2>\n</div>\n',
      minified: '<div id='id1' class='class1'> <h1>Hello</h1> <h2>Hi</h2></div>',
      includes: ['/home/johndoe/Projects/testapp/markup/templates/_hi.jade'],
      errors:   [],
      warnings: []
    }

- __source__: *(string)* source code (if loaded from file)
- __compiled__: *(string)* compiled, unminified code (on compilation requests)
- __minified__: *(string)* minified code (on minification requests)
- __includes__: *(Array)* of *(string)*s included files (only used for Jade, Less and Sass files with includes/import)
- __errors__: *(Array)* of *(Error)*-inherited objects
- __warnings__: *(Array)* of *(Error)*-inherited objects

## Consequent Errors and Warnings
Objects created using instances of object inherited from JavaScript-native Error class:

    {
      title:   'Syntax Error',
      message: 'Unexpected <',
      file:    'src/test.coffee',
      line:    2,
      column:  6,
      sourceLines: {
        0: 'x = (a) ->',
        1: '  a + 1',
        2: '  x = <-',
        3: ''
      }
    }

*multic* attempts to provide a unified interface for all errors and warnings. You get these properties on the errors/warnings:
- __message__: *(string)* literal description of the error/warning
- __title__: *(string)* short description of the error/warning
- __file__: *(string)* file path of error
- __line__: *(number)* indication of error/warning line (0-based index, i.e. first line is line 0)
- __column__: *(number)* indication of error/warning column in line (0-based index, i.e. first column is column 0)
- __sourceLines__: *(number)* a snippet of the source code around the error/warning. Keys are 0-based line numbers, values are the lines (without the \n character at the end). 11 lines (error/warning line + 5 previous + 5 following lines) or less (when the line is near the start or end of file).

WARNING! Although these properties are available most of the time, keep in mind that:
- *jade* related errors and warnings usually will not have `column` property
- `file` property is only added if
  - source is loaded from file, or
  - you have specified {file: '/my/file/name.ext'} as option with your source string (see below)
- some exotic errors may not have anything but message (and file if source is loaded from file or you sp)

## Options
### `file` file path for source string
This is useful for error messages and to define include path start point for Jade, Less and Sass includes/imports

    multic(source_string, {file: '*path/to/my/source/file.ext*'}).min(callback);

### `moduleName` string for Angulat module generator (`html.js` and `jade.js` compilers)
Define Angular module name for your markup.

    multic(source_string, {moduleName: 'name.space.joe'}).html.js(callback);

### Configurable lint rules
See [table of lint rules](docs/lint-rules.md)

    multic(source_file_path, {
      max_line_length:  80,
      file_end_newline: false
      // ...
    }).file.min(callback);

### Turn off linting
Pass `{lint: false}` option explicitly to disable linting.

    multic(source, {lint: false}).js.min(callback);

# Utilized minifiers
- html: [html-minifier](https://www.npmjs.com/package/html-minifier)
- javascript: [uglify-js](https://www.npmjs.com/package/uglify-js)
- css: [clean-css](https://www.npmjs.com/package/clean-css)

## Utilized external linters
- coffee: [coffee-lint](https://www.npmjs.com/package/jshint)
- css: [csslint](https://www.npmjs.com/package/csslint)
- html: [htmllint](https://www.npmjs.com/package/htmllint)
- js & es6: [jshint](https://www.npmjs.com/package/jshint)

## Promises
Used library: [promise](https://www.npmjs.com/package/promise)

# Coming soon (TODO)
- Missing lint rule implementations and tests, added descriptions and links for rules
- CLI

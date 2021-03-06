# angular-klaxon

[Bootstrap](http://getbootstrap.com/)-compatible, configurable [alerts](http://getbootstrap.com/components/#alerts) for your [angular app](https://angularjs.org/).

![The official Klaxon logo, a cartoon Klaxon alarm](https://raw.github.com/goodeggs/angular-klaxon/master/doc/klaxon.png)

[![Build Status](http://img.shields.io/travis/goodeggs/ng-klaxon.svg?style=flat-square)](https://travis-ci.org/goodeggs/ng-klaxon)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/goodeggs/angular-klaxon/blob/master/LICENSE.md)

## Usage

0. Install from:

  - NPM: `npm install angular-klaxon`
  - Bower: `bower install angular-klaxon`

1. Register it as an angular dependency:

  ```javascript
  // option 1 (include the built javascript in your page)
  var app = angular.module('app', ['klaxon']);

  // option 2 (use commonjs, like browserify or webpack)
  var app = angular.module('app', [require('angular-klaxon').name]);
  ```

2. Include the `klaxon-alert-container` directive in your html somewhere:

  ```html
  <div class='container'>
    <klaxon-alert-container></klaxon-alert-container>
  </div>
  ```

3. Trigger alerts from your app!

  ```javascript
  app.controller('MyController', ['KlaxonAlert', function (KlaxonAlert) {
    alert = new KlaxonAlert('The floor is lava!', {
      type: 'danger',
      timeout: 1000
    });
    alert.add();
  }]);
  ```

  ![Screenshot of an alert showing up in a browser window](https://raw.github.com/goodeggs/angular-klaxon/master/doc/demo.png)

## Documentation

Inject `KlaxonAlert`. It's a constructor function with the following API:

```js
alert = new KlaxonAlert(msg, options)
```

- `msg` (`String`): The message that should be displayed on the alert
- `options` (`Object`, optional): Additional configuration for your alert
  - `type` (`String`, default `"info"`): Your alert will be given the class
    `alert-<class>`. We recommend you use one of the [bootstrap
    defaults](http://getbootstrap.com/components/#alerts):
    - `success`
    - `info`
    - `warning`
    - `danger`
  - `closable` (`Boolean`, default `true`): Whether or not to display a "close"
    button on the alert.
  - `timeout` (`Number`): If this is set, the alert will disappear after
    `timeout` milliseconds have passed.
  - `callToAction` (`String`): If this is set, this string will be displayed
    after the message as a clickable link.
  - `onCallToActionClick` (`Function`): If this is set in addition to callToAction, clicking on the call to action message will call this function.
    function.
  - `onClick` (`Function`): If this is set, clicking on the alert will call this
    function.
  - `debugInfo` (`String`): If this is set, it will be displayed below the
    klaxon with a class of `debug-info`. (Good for UUIDs that can be displayed
    alongside error messages, for example.)
  - `priority` (`Number`): The `klaxon-alert-container` will display messages in
    order of `priority`, highest first.
  - `key` (`String`): The `klaxon-alert-container` won't ever show more than one
    alert with the same key. This is useful if you want to avoid displaying the
    same message over and over again. The message with the highest `priority`
    (or the most recent message if they all have the same `priority`) will be the
    one that is displayed.

- `alert` (`KlaxonAlert`): An instance with the following methods:
  - `add`: Adds the alert to the `klaxon-alert-container`
  - `close`: Removes the alert from the `klaxon-alert-container`
  - `click`: Calls the `onClick` handler for the alert, if one is set.

## Contributing

Please follow our [Code of Conduct](https://github.com/goodeggs/mongoose-webdriver/blob/master/CODE_OF_CONDUCT.md)
when contributing to this project.

```
$ git clone https://github.com/goodeggs/ng-klaxon && cd ng-klaxon
$ npm install
$ npm test
```

_Module scaffold generated by [generator-goodeggs-npm](https://github.com/goodeggs/generator-goodeggs-npm)._

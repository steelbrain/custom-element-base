Custom-Element-Base
==================

Custom-Element-Base is a base module that allows its consumers to painlessly define custom elements. It automatically manages the config attributes and their type-conversion. You can focus on doing your part and leave the rest to it.

#### Features

  - Less than 2 kb minified
  - Provides config management
  - Provides types for configs
  - Allows JSON types
  - Automatically matches HTML attributes with element properties
  - Automatically extracts initial attributes into config

#### API

```js
type Config<T> = {
  type: enum<T>{ Object, String, Number, Boolean, 'JSON' },
  default: T
}
function registerCustomElement({
  name: String,
  ?created: Function,
  ?initialize: Function,
  ?attached: Function,
  ?detached: Function,
  ?attributeChanged: Function,
  ?config: Array<string, Config>
  .... // <-- any other properties will be copied directly to that element's prototype
})
```

#### Examples

```js
const MyElement = registerCustomElement({
  name: 'my-element',
  initialize: function() {
    console.log(this.super, this.name)
  },
  config: {
    super: {type: Boolean, default: true}
    name: {type: String}
  }
})
const el = new MyElement() // or document.createElement('my-element')
el.name = 'SteelBrain'
document.body.appendChild(el)
// true, 'SteelBrain' <-- will be logged to dev console
```

#### Notes

  - If no default is specified and value is not given, null is returned in getter
  - JSON attributes are removed from DOM immediately after use but are still present in the element object
  - Object attributes are not set or removed from DOM
  - Config keys are lowercased to match HTML behavior

#### LICENSE

This project is licensed under the terms of MIT License

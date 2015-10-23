'use strict'

// @Compiler-Transpile "true"
// @Compiler-Compress "true"
// @Compiler-Output "base.min.js"

function registerCustomElement({name, created, initialize, attached, detached, attributeChanged, config = {}}) {
  const element = Object.create(HTMLElement.prototype)
  element.createdCallback = function() {
    const elementConfig = this.__config = {__init: false}
    const element = this
    for (let name in config) {
      if (config.hasOwnProperty(name)) {
        const current = config[name]
        name = name.toLowerCase()
        if (typeof current.type === 'undefined') {
          current.type = String
        }
        if (typeof current.default !== 'undefined') {
          elementConfig[name] = registerCustomElement.normalizeType(current.type, current.type === Object ? Object.create(current.default) : current.default)
        }
        Object.defineProperty(element, name, {
          set: function(value) {
            if (current.type !== Object) {
              element.setAttribute(name, value)
            }
            elementConfig[name] = registerCustomElement.normalizeType(current.type, value)
          },
          get: function() {
            if (typeof elementConfig[name] !== 'undefined') {
              return elementConfig[name]
            }
            return null
          }
        })
      }
    }
    for (let i = 0 ; i < element.attributes.length; ++ i) {
      const current = element.attributes[i]
      this[current.name] = current.value
    }
    if (typeof created !== 'undefined') {
      created.call(this)
    }
  }
  element.attachedCallback = function() {
    if (!this.__config.__init) {
      this.__config.__init = true
      if (typeof initialize !== 'undefined') {
        initialize.call(this)
      }
    }
    if (typeof attached !== 'undefined') {
      attached.call(this)
    }
  }
  element.detachedCallback = function() {
    if (typeof detached !== 'undefined') {
      detached.call(this)
    }
  }
  element.attributeChangedCallback = function(attrName, oldVal, newVal) {
    if (attrName in config) {
      this[attrName] = newVal === null ? true : newVal
    } else {
      if (typeof attributeChanged !== 'undefined') {
        attributeChanged.call(this, {attrName, new: newVal, old: oldVal})
      }
    }
  }
  return document.registerElement(name, {prototype: element});
}
registerCustomElement.normalizeType = function(type, value) {
  if (value instanceof type) {
    return value
  } else return type(value)
}

if (typeof module !== 'undefined') {
  module.exports = registerCustomElement
}

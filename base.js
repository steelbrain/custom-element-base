'use strict'

function registerCustomElement({name, created, attached, detached, attributeChanged, config: {}}) {
  const element = Object.create(HTMLElement.prototype)
  element.createdCallback = function() {
    const elementConfig = this.config = {__init: false}
    const element = this
    for (let name in config) {
      if (config.hasOwnProperty(name)) {
        const current = config[name]
        current.default = current.default || null
        Object.defineProperty(elementConfig, name, {
          get: function() {
            return elementConfig[`_${name}`] || element.getAttribute(name) || current.default
          },
          set: function(value) {
            elementConfig[`_${name}`] = value
          }
        })
      }
    }
  }
  element.attachedCallback = function() {
    if (!this.config.__init) {
      this.config.__init = true
      created.call(this)
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
  element.attributeChangedCallback = function({attrName, oldVal, newVal}) {
    if (typeof attributeChanged !== 'undefined') {
      attributeChanged.call(this, {attrName, new: newVal, old: oldVal})
    }
  }
  return document.registerElement(name, {prototype: element});
}

if (typeof module !== 'undefined') {
  module.exports = registerCustomElement
}

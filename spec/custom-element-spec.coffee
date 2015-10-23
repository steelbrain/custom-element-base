describe 'Custom Element Base', ->
  registerCustomElement = require('../base.min.js')
  {getCustomElement} = require('./helper')

  it 'fires the events in order', ->
    lastRan = null
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-event-order'
      created: -> lastRan = 'created'
      initialize: -> lastRan = 'initialize'
      attached: ->
        expect(lastRan).toBe('initialize')
        lastRan = 'attached'
      detached: -> lastRan = 'detached'
      attributeChanged: -> lastRan = 'attributeChanged'
    })))
    expect(lastRan).toBe('created')
    element.setAttribute('a-b', 'c')
    expect(lastRan).toBe('attributeChanged')
    document.body.appendChild(element)
    expect(lastRan).toBe('attached')
    element.remove()
    expect(lastRan).toBe('detached')

  it 'lowercases config keys', ->
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-lowercase-config-keys',
      config: {Wow: {type: Boolean, default: false}}
    })))
    expect(element.Wow).toBeUndefined()
    expect(element.wow).toBe(false)

  it 'returns null for non-specified config keys', ->
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-return-null-nonspecified-keys'
      config: {wow: {type: Boolean}}
    })))
    expect(element.wow).toBe(null)

  it 'updates the attribute on html struct itself', ->
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-updates-attribute-html-struct'
      config: {wow: {type: Boolean}}
    })))
    expect(element.hasAttribute('wow')).toBe(false)
    element.wow = true
    expect(element.getAttribute('wow')).toBe('true')

  it 'duplicates the default if its an object', ->
    defaultProp = {a: 'b'}
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-duplicate-default-if-object'
      config: {wow: {type: Object, default: defaultProp}}
    })))
    expect(element.wow).not.toBe(defaultProp)
    expect(element.wow.__proto__).toBe(defaultProp)

  it 'does not show object configs in html attributes', ->
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-doesnt-show-object-config-html-attributes'
      config: {wow: {type: Object}}
    })))
    expect(element.hasAttribute('wow')).toBe(false)
    element.wow = {}
    expect(element.hasAttribute('wow')).toBe(false)

  it 'automatically removes JSON attributes after using', ->
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-automatically-remove-json-attributes'
      config: {wow: {type: 'JSON'}}
    })))
    element.setAttribute('wow', '[]')
    expect(element.hasAttribute('wow')).toBe(false)
    expect(element.wow instanceof Array).toBe(true)
    expect(element.wow.length).toBe(0)

  it 'automatically uses the existing html attributes in config', ->
    name = 'x-spec-automatically-resume-config-attributes'
    registerCustomElement(getCustomElement({
      name,
      config: {wow: {type: Boolean}}
    }))
    container = document.createElement('div')
    container.innerHTML = "<#{name} wow='true'></#{name}>"
    expect(container.childNodes[0].wow).toBe(true)

  it 'does not fire attributeChanged on config change', ->
    executed = false
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-attributechanged-fired'
      attributeChanged: -> executed = true
      config: {asd: {type: Boolean, default: false}}
    })))
    element.setAttribute('asd', false)
    expect(executed).toBe(false)
    element.setAttribute('asd-a', false)
    expect(executed).toBe(true)

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

  it 'lowercases config values', ->
    element = new (registerCustomElement(getCustomElement({
      name: 'x-spec-lowercase-config-values',
      config: {Wow: {type: Boolean, default: false}}
    })))
    expect(element.Wow).toBeUndefined()
    expect(element.wow).toBe(false)

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

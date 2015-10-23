describe 'Custom Element Base', ->
  registerCustomElement = require('../base.min.js')
  {getCustomElement} = require('./helper')

  it 'fires the events in order', ->
    lastRan = null
    element = new (registerCustomElement(getCustomElement({
      name: 'x-custom-element'
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


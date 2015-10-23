module.exports =

  getCustomElement: ({name, created, initialize, attached, detached, attributeChanged, config}) ->
    created ?= ->
    initialize ?= ->
    attached ?= ->
    detached ?= ->
    attributeChanged ?= ->
    config ?= {}
    return {name, created, initialize, attached, detached, attributeChanged, config}

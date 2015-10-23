module.exports =

  getCustomElement: ({name, created, initialize, attached, detached, attributeChanged, config, proto}) ->
    created ?= ->
    initialize ?= ->
    attached ?= ->
    detached ?= ->
    attributeChanged ?= ->
    config ?= {}
    proto ?= {}
    return {name, created, initialize, attached, detached, attributeChanged, config, proto}

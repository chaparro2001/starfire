Rx = require 'rx-lite'

module.exports = class InstallOverlay
  constructor: ->
    @_isOpen = new Rx.BehaviorSubject false
    @onActionFn = null

  isOpen: =>
    @_isOpen

  onAction: (@onActionFn) => null

  setPrompt: (@prompt) => null

  open: =>
    @_isOpen.onNext true
    # prevent body scrolling while viewing menu
    document.body.style.overflow = 'hidden'

  close: =>
    @_isOpen.onNext false
    @onAction null
    document.body.style.overflow = 'auto'

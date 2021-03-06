z = require 'zorium'
_defaults = require 'lodash/defaults'

Icon = require '../icon'
FlatButton = require '../flat_button'
config = require '../../config'
colors = require '../../colors'

if window?
  require './index.styl'

module.exports = class Sheet
  constructor: ({@router, @isVisible}) ->
    @$icon = new Icon()
    @$closeButton = new FlatButton()
    @$submitButton = new FlatButton()

  afterMount: =>
    @router.onBack =>
      @isVisible.onNext false

  # beforeUnmount: =>
  #   @isVisible.onNext false

  render: ({icon, message, submitButton, $content}) =>
    z '.z-sheet',
      z '.overlay',
        onclick: =>
          @isVisible.onNext false
      z '.sheet',
        z '.inner',
          if $content
            $content
          else
            [
              z '.content',
                z '.icon',
                  z @$icon,
                    icon: icon
                    color: colors.$primary500
                    isTouchTarget: false
                z '.message', message
              z '.actions',
                z @$closeButton,
                  text: 'Not now'
                  isFullWidth: false
                  onclick: =>
                    @isVisible.onNext false
                z @$submitButton, _defaults submitButton, {
                  isFullWidth: false
                  colors: {cText: colors.$primary500}
                }
            ]

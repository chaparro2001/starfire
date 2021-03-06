z = require 'zorium'
Rx = require 'rx-lite'

colors = require '../../colors'

if window?
  require './index.styl'

module.exports = class Input
  constructor: ({@value, @valueStreams, @error, @isFocused} = {}) ->
    @value ?= Rx.BehaviorSubject ''
    @error ?= new Rx.BehaviorSubject null

    @isFocused ?= new Rx.BehaviorSubject false

    @state = z.state {
      isFocused: @isFocused
      value: @valueStreams?.switch() or @value
      error: @error
    }

  render: (props) =>
    {colors, hintText, type, isFloating, isDisabled,
      isDark, isCentered} = props

    {value, error, isFocused} = @state.getValue()

    colors ?= {
      c500: colors.$black
    }
    hintText ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false

    z '.z-input',
      className: z.classKebab {
        isDark
        isFloating
        hasValue: value isnt ''
        isFocused
        isDisabled
        isCentered
        isError: error?
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors.c500 else null
      },
        hintText
      z 'input.input',
        attributes:
          disabled: if isDisabled then true else undefined
          type: type
        value: value
        oninput: z.ev (e, $$el) =>
          if @valueStreams
            @valueStreams.onNext Rx.Observable.just $$el.value
          else
            @value.onNext $$el.value
        onfocus: z.ev (e, $$el) =>
          @isFocused.onNext true
        onblur: z.ev (e, $$el) =>
          @isFocused.onNext false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors.c500 else null
      if error?
        z '.error', error

z = require 'zorium'
Rx = require 'rx-lite'
_map = require 'lodash/map'
_range = require 'lodash/range'
_filter = require 'lodash/filter'
_find = require 'lodash/find'

DeckCards = require '../../components/deck_cards'

if window?
  require './index.styl'

CARDS_PER_DECK = 8

module.exports = class DeckPicker
  constructor: ({@model, @selectedCards, @selectedCardsStreams}) ->
    if @selectedCardsStreams
      @selectedCards = @selectedCardsStreams.switch()

    selectedDeck = @selectedCards.map (cards) ->
      {cards: _map _range(CARDS_PER_DECK), (i) -> cards[i]}

    allCards = @model.clashRoyaleCard.getAll()
    allCardsAndSelectedCards = Rx.Observable.combineLatest(
      allCards
      @selectedCards
      (vals...) -> vals
    )
    allDeck = allCardsAndSelectedCards.map ([allCards, selectedCards]) ->
      cards = _filter allCards, (card) ->
        not _find selectedCards, {id: card.id}
      {cards}
    @$selectedCards = new DeckCards {deck: selectedDeck}
    @$allCards = new DeckCards {deck: allDeck}

    @state = z.state
      selectedCards: @selectedCards

  render: =>
    {selectedCards} = @state.getValue()

    z '.z-deck-picker',
      z '.selected',
        z @$selectedCards,
          onCardClick: (card) =>
            newCards = _filter selectedCards, (selectedCard) ->
              card.id isnt selectedCard?.id
            if @selectedCardsStreams
              @selectedCardsStreams.onNext Rx.Observable.just newCards
            else
              @selectedCards.onNext newCards
      z '.cards',
        z '.scroller',
          z @$allCards, {
            onCardClick: (card) =>
              if selectedCards.length < CARDS_PER_DECK
                newCards = selectedCards.concat [card]
                if @selectedCardsStreams
                  @selectedCardsStreams.onNext Rx.Observable.just newCards
                else
                  @selectedCards.onNext newCards
          }

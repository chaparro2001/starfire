z = require 'zorium'
Rx = require 'rx-lite'

Head = require '../../components/head'
AppBar = require '../../components/app_bar'
ButtonMenu = require '../../components/button_menu'
Clan = require '../../components/clan'
BottomBar = require '../../components/bottom_bar'
Spinner = require '../../components/spinner'
colors = require '../../colors'
config = require '../../config'

if window?
  require './index.styl'

module.exports = class ClanPage
  constructor: ({@model, requests, @router, serverData}) ->
    id = requests.map ({route}) ->
      if route.params.id then route.params.id else false

    me = @model.user.getMe()
    gameData = me.flatMapLatest ({id}) =>
      @model.player.getByUserIdAndGameId id, config.CLASH_ROYALE_ID

    gameDataAndId = Rx.Observable.combineLatest(gameData, id, (vals...) -> vals)

    clan = gameDataAndId.flatMapLatest ([gameData, id]) =>
      if id
        @model.clan.getById id
        .map (clan) -> clan or false
      else if gameData?.clanId
        @model.clan.getById gameData?.clanId
        .map (clan) -> clan or false
      else
        Rx.Observable.just false

    @$head = new Head({
      @model
      requests
      serverData
      meta: {
        title: 'Clan'
        description: 'Clan'
      }
    })
    @$appBar = new AppBar {@model}
    @$buttonMenu = new ButtonMenu {@model}
    @$spinner = new Spinner()

    @$clan = new Clan {@model, @router, clan}
    @$bottomBar = new BottomBar {@model, @router, requests}

    @state = z.state
      windowSize: @model.window.getSize()
      clan: clan

  renderHead: => @$head

  render: =>
    {windowSize, clan} = @state.getValue()

    z '.p-clan', {
      style:
        height: "#{windowSize.height}px"
    },
      z @$appBar, {
        title: 'Clan'
        isFlat: true
        $topLeftButton: z @$buttonMenu, {color: colors.$tertiary900}
      }
      if clan
        @$clan
      else if clan is false
        z '.empty', 'Looks like you\'re not in a clan'
      else
        @$spinner
      @$bottomBar

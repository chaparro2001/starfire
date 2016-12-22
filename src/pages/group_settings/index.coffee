z = require 'zorium'

Head = require '../../components/head'
GroupSettings = require '../../components/group_settings'
AppBar = require '../../components/app_bar'
ButtonBack = require '../../components/button_back'
colors = require '../../colors'

if window?
  require './index.styl'

module.exports = class GroupSettingsPage
  hideDrawer: true

  constructor: ({model, requests, @router, serverData}) ->
    group = requests.flatMapLatest ({route}) ->
      model.group.getById route.params.id

    @$head = new Head({
      model
      requests
      serverData
      meta: {
        title: 'Group Settings'
        description: 'Group Settings'
      }
    })
    @$appBar = new AppBar {@model}
    @$buttonBack = new ButtonBack {@model, @router}
    @$groupSettings = new GroupSettings {model, @router, serverData, group}

  renderHead: => @$head

  render: =>
    z '.p-group-settings', {
      style:
        height: "#{window?.innerHeight}px"
    },
      z @$appBar, {
        title: 'Group Settings'
        isFlat: true
        $topLeftButton: z @$buttonBack, {color: colors.$tertiary900}
      }
      @$groupSettings
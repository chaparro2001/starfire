

z = require 'zorium'

Head = require '../../components/head'
GroupManageChannels = require '../../components/group_manage_channels'
AppBar = require '../../components/app_bar'
ButtonBack = require '../../components/button_back'
colors = require '../../colors'

if window?
  require './index.styl'

module.exports = class GroupManageChannelsPage
  hideDrawer: true

  constructor: ({model, requests, @router, serverData}) ->
    group = requests.flatMapLatest ({route}) ->
      model.group.getById route.params.id

    user = requests.flatMapLatest ({route}) ->
      model.user.getById route.params.userId

    @$head = new Head({
      model
      requests
      serverData
      meta: {
        title: 'Manage Channels'
        description: 'Manage Channels'
      }
    })
    @$appBar = new AppBar {@model}
    @$buttonBack = new ButtonBack {@model, @router}
    @$groupManageChannels = new GroupManageChannels {
      model, @router, serverData, group, user
    }

    @state = z.state
      windowSize: model.window.getSize()

  renderHead: => @$head

  render: =>
    {windowSize} = @state.getValue()

    z '.p-group-manage-channels', {
      style:
        height: "#{windowSize.height}px"
    },
      z @$appBar, {
        title: 'Manage Channels'
        style: 'secondary'
        isFlat: true
        $topLeftButton: z @$buttonBack, {color: colors.$primary500}
      }
      @$groupManageChannels

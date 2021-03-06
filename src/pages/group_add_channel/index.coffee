z = require 'zorium'

Head = require '../../components/head'
GroupEditChannel = require '../../components/group_edit_channel'

if window?
  require './index.styl'

module.exports = class GroupAddChannelPage
  hideDrawer: true

  constructor: ({model, requests, @router, serverData}) ->
    group = requests.flatMapLatest ({route}) ->
      model.group.getById route.params.id

    @$head = new Head({
      model
      requests
      serverData
      meta: {
        title: 'Add Channel'
        description: 'Add Channel'
      }
    })
    @$groupEditChannel = new GroupEditChannel {
      model, @router, serverData, group
    }

    @state = z.state
      group: group
      windowSize: model.window.getSize()

  renderHead: => @$head

  render: =>
    {group, windowSize} = @state.getValue()

    z '.p-group-add-channel', {
      style:
        height: "#{windowSize.height}px"
    },
      z @$groupEditChannel, {isNewChannel: true}

Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
ms = require 'ms'

{ MainController } = require 'agate/src/controllers'
{ SlideDownRegion } = require 'agate/src/regions'
Util = require 'agate/src/apputil'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
HubChannel = Backbone.Radio.channel 'hubby'

class AppletLayout extends Backbone.Marionette.View
  template: tc.renderable () ->
    tc.div '.row', ->
      tc.div  '#main-toolbar.col-sm-6.col-sm-offset-3'
    tc.div '.row', ->
      tc.div '#main-content.col-sm-10.col-sm-offset-1'
  regions: ->
    region = new SlideDownRegion
      el: '#main-content'
    region.slide_speed = ms '.01s'
    content: region
    toolbar: '#main-toolbar'
    
class ToolbarView extends Backbone.Marionette.View
  template: tc.renderable () ->
    tc.div '.btn-group.btn-group-justified', ->
      tc.div '#show-calendar-button.btn.btn-default', ->
        tc.i '.fa.fa-calendar', ' Calendar'
      tc.div '#list-meetings-button.btn.btn-default', ->
        tc.i '.fa.fa-list', ' List Meetings'
  ui:
    show_cal_btn: '#show-calendar-button'
    list_btn: '#list-meetings-button'
  events:
    'click @ui.show_cal_btn': 'show_calendar'
    'click @ui.list_btn': 'list_meetings'

  show_calendar: ->
    Util.navigate_to_url '#hubby'

  list_meetings: ->
    Util.navigate_to_url '#hubby/listmeetings'
      
class Controller extends MainController
  layoutClass: AppletLayout
  setup_layout_if_needed: ->
    super()
    @layout.showChildView 'toolbar', new ToolbarView

  show_calendar: (layout, region) ->
    #console.log "show_calendar", layout, region
    require.ensure [], () =>
      MeetingCalendarView  = require './calendarview'
      options = {}
      if region == 'minicalendar'
        options.minicalendar = true
        options.layout = layout
      view = new MeetingCalendarView options
      layout.showChildView region, view
    # name the chunk
    , 'hubby-show-calendar'
    
  mainview: ->
    @setup_layout_if_needed()
    #console.log "mainview"
    @show_calendar @layout, 'content'
    

  list_meetings: ->
    @setup_layout_if_needed()
    require.ensure [], () =>
      { MainMeetingModel } = require './collections'
      meetings = HubChannel.request 'meetinglist'
      ListMeetingsView = require './listmeetingsview'
      response = meetings.fetch()
      response.done =>
        view = new ListMeetingsView
          collection: meetings
        @layout.showChildView 'content', view
      response.fail =>
        MessageChannel.request 'danger', 'Failed to load meeting list'
    # name the chunk
    , 'hubby-list-meetings-view'

    

  show_meeting: (layout, region, meeting_id) ->
    require.ensure [], () =>
      { MainMeetingModel } = require './collections'
      ShowMeetingView  = require './meetingview'
      meeting = new MainMeetingModel
        id: meeting_id
      response = meeting.fetch()
      response.done =>
        view = new ShowMeetingView
          model: meeting
        layout.showChildView region, view
      response.fail =>
        MessageChannel.request 'danger', 'Failed to load meeting'
    # name the chunk
    , 'hubby-meetingview'
    
  view_meeting: (meeting_id) ->
    @setup_layout_if_needed()
    @show_meeting @layout, 'content', meeting_id
    

    
module.exports = Controller


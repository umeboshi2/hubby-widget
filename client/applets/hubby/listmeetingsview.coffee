Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

#FullCalendar = require 'fullcalendar'

# FIXME
#require '../../node_modules/fullcalendar/dist/fullcalendar.css'
#require 'fullcalendar/dist/fullcalendar.css'

HubChannel = Backbone.Radio.channel 'hubby'

#################################
# templates
#################################

tc = require 'teacup'

meeting_calendar = tc.renderable () ->
  tc.div '.listview-header', 'Meetings'
  tc.div '#loading', ->
    tc.h2 'Loading Meetings'
  tc.div '#maincalendar'
#################################

render_calendar_event = (calEvent, element) ->
  calEvent.url = "#hubby/viewmeeting/#{calEvent.id}"
  element.css
    'font-size' : '0.9em'

calendar_view_render = (view, element) ->
  HubChannel.request 'maincalendar:set-date'
  
loading_calendar_events = (bool) ->
  loading = $ '#loading'
  header = $ '.fc-header'
  if bool
    loading.show()
    header.hide()
  else
    loading.hide()
    header.show()

class SimpleMeetingView extends Backbone.Marionette.View
  template: tc.renderable (model) ->
    name = "meeting"
    item_btn = ".btn.btn-default.btn-xs"
    tc.li ".list-group-item.#{name}-item", ->
      tc.span ->
        tc.a href:"#hubby/viewmeeting/#{model.id}", model.title
      #tc.div '.btn-group.pull-right', ->
      #  tc.button ".edit-item.#{item_btn}.btn-info.fa.fa-edit", 'edit'
      #  tc.button ".delete-item.#{item_btn}.btn-danger.fa.fa-close", 'delete'

class ListMeetingsView extends Backbone.Marionette.CompositeView
  childView: SimpleMeetingView
  template: tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text "Meetings"
    tc.hr()
    tc.ul "#meetings-container.list-group"


module.exports = ListMeetingsView
  

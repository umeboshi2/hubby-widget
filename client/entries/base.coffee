$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

{ string_endswith } = require 'agate/src/apputil'
# use polyfill for String.endsWith if needed
if not String.prototype?.endsWith
  String.prototype.endsWith = string_endswith


  
require 'bootstrap'

MainChannel = Backbone.Radio.channel 'global'
  
class MainPageLayout extends Backbone.Marionette.View
  template: tc.renderable ->
    tc.div '.container-fluid', ->
      tc.div '#applet-content.row'
  regions:
    applet: '#applet-content'
    

if __DEV__
  console.warn "__DEV__", __DEV__, "DEBUG", DEBUG
  Backbone.Radio.DEBUG = true
  #FIXME
  window.chnnl = MainChannel
  
######################
# start app setup

MainChannel.reply 'mainpage:init', (appmodel) ->
  # get the app object
  app = MainChannel.request 'main:app:object'
  # initialize the main view
  app.showView new MainPageLayout
  # emit the main view is ready
  MainChannel.trigger 'mainpage:displayed'


module.exports = {}

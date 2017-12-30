Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

require './base'

prepare_app = require 'agate/src/app-prepare'

appmodel = require './base-appmodel'

######################

# FIXME this should already be empty
appmodel.set 'applets', []

brand = appmodel.get 'brand'
brand.url = '#'
appmodel.set brand: brand
  
MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
HubChannel = Backbone.Radio.channel 'hubby'


# FIXME this should already be empty
appmodel.set 'applet_menus', []

# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  appmodel

# require applets
require '../applets/hubby/main'

app = prepare_app appmodel

if __DEV__
  # DEBUG attach app to window
  window.App = app

MainChannel.on 'mainpage:displayed', ->
  # this handler is useful if there are views that need to be
  # added to the navbar.  The navbar should have regions to attach
  # the views
  # --- example ---
  # view = new view
  # aregion = MainChannel.request 'main:app:get-region', aregion
  # aregion.show view

  app = MainChannel.request 'main:app:object'
  appmodel = MainChannel.request 'main:app:appmodel'
  HubChannel = Backbone.Radio.channel 'hubby'
  HubChannel.request 'main-calendar'
  

# start the app
app.start()
console.log 'app started'

module.exports = app



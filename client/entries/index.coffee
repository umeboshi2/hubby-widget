Marionette = require 'backbone.marionette'

require './base'

prepare_app = require 'agate/src/app-prepare'

appmodel = require './base-appmodel'

# FIXME this should already be empty
appmodel.set 'applets', []

brand = appmodel.get 'brand'
brand.url = '#'
appmodel.set brand: brand
  
MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'


# FIXME this should already be empty
appmodel.set 'applet_menus', []

# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  appmodel

######################
# require applets
require '../applets/xmlst/main'

app = prepare_app appmodel

if __DEV__
  # DEBUG attach app to window
  window.App = app

# start the app
app.start()

module.exports = app



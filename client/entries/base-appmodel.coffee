$ = require 'jquery'
jQuery = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'

BaseAppModel = require 'agate/src/appmodel'

tc = require 'teacup'

appmodel = new BaseAppModel
  hasUser: false
  needUser: false
  brand:
    name: 'FCD#3'
    url: '/'
  frontdoor_app: 'xmlst'

module.exports = appmodel

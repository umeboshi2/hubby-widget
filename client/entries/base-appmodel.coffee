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
    name: 'Hubby'
    url: '/'
  frontdoor_app: 'hubby'

module.exports = appmodel

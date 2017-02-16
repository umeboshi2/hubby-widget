beautify = require('js-beautify').html

pages = require './templates'
webpackManifest = require '../build/manifest.json'


# FIXME require this  
UseMiddleware = process.env.PRODUCTION_BUILD is 'false'
get_manifest = (name) ->
  if UseMiddleware
    manifest =
      'vendor.js': 'vendor.js'
      'agate.js': 'agate.js'
    filename = "#{name}.js"
    manifest[filename] = filename
  else
    manifest = webpackManifest
  return manifest

    
create_page_html = (name, manifest, theme) ->
  page = pages[name] manifest, theme
  beautify page

  
write_page = (page, res, next) ->
  make_page_header res, page
  res.write page
  res.end()
  next()      

make_page = (name) ->
  # FIXME make a site config
  theme = 'cornsilk'
  manifest = get_manifest name
  page = create_page_html name, manifest, theme
  return page
  
module.exports =
  make_page: make_page

Refinery::Core.configure do |config|
  # Register extra javascript for backend
  config.register_javascript "refinery/admin/wymeditor_monkeypatch.js"

  #Register extra stylesheet for backend (optional options)
  config.register_stylesheet "refinery/admin/video.css"
end

Refinery::Wymeditor.configure do |config|

# Add extra tags to the wymeditor whitelist e.g. = {'tag'=> {'attributes'=> {'1'=> 'href'}}} or just {'tag'=> {}}
# config.whitelist_tags =  {'span'=> {
# 'attributes'=> {
# '1'=> 'data-tooltip'
# }}}
  config.whitelist_tags =
  {'video' => {
    'attributes'=> {
      '0'=> 'width',
      '1'=> 'height',
      '2'=> 'poster',
      '3'=> 'data-setup'
    }
  },
  'source'=> {
    'attributes'=> {
      '0'=> 'src',
      '1'=> 'type'
    }
  }
}
end


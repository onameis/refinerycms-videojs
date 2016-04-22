module VideosHelper
include ActionView::Helpers::TagHelper
include ActionView::Context

  def embed_html(video)
    if video.use_shared
      update_from_config(video.embed_tag)
      return embed_tag.html_safe
    end

    data_setup = {}
    ::Refinery::Videos::Video::CONFIG_OPTIONS.keys.reject{|opt| [:height, :width].include?(opt)}.each do |option|
      data_setup[option] = video.config[option] || 'auto'
    end


    options = {
      id: "video_#{video.id}",
      class: "video_js #{Refinery::Videos.skin_css_class}",
      width: video.config[:width],
      height: video.config[:height],
      data: data_setup.to_json,
      poster: video.poster.url||''
      }

    sources = sources_html(video)
    content_tag(:video, sources_html(video), options, escape: false)
  end

  def sources_html(video)
    video.video_files.each.inject(ActiveSupport::SafeBuffer.new) do |buffer, file|
      options = {
        src: file.use_external ? file.external_url : file.url,
        type: file.mime_type || file.file_mime_type
      }
      source = tag(:source, options, escape: false )
      Rails.logger.debug '---------'
      Rails.logger.debug source
      buffer  << source if file.exist?
    end
  end

  def update_from_config(tag)
    tag.gsub!(/width="(\d*)?"/, "width=\"#{video.config[:width]}\"")
    tag.gsub!(/height="(\d*)?"/, "height=\"#{video.config[:height]}\"")
    # fix iframe overlay
    if tag.include? 'iframe'
      tag =~ /src="(\S+)"/
      tag.gsub!(/src="\S+"/, "src=\"#{$1}?wmode=transparent\"")
    end
  end
end
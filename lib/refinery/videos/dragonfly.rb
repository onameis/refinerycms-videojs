require 'dragonfly'

module Refinery
  module Videos
    module Dragonfly

      class << self
        def configure!
          app_videos = ::Dragonfly.app(:refinery_videos)

          app_videos.configure do
            plugin :imagemagick
            url_format Refinery::Videos.dragonfly_url_format
            url_host Refinery::Videos.dragonfly_url_host
            verify_urls Refinery::Videos.dragonfly_verify_urls
            if Refinery::Videos.dragonfly_verify_urls
              secret Refinery::Videos.dragonfly_secret
            end
            dragonfly_url nil
            response_header 'Content-Disposition' 'attachment;'
            datastore :file, {:root_path => Refinery::Videos.datastore_root_path}
            if ::Refinery::Videos.s3_backend
              datatstore :file, {
                bucket_name:   Refinery::Videos.s3_bucket_name,
                access_key_id: Refinery::Videos.s3_access_key_id,
                secret_access_key: Refinery::Videos.s3_secret_access_key
              }.tap { |ds|
	                # S3 Region otherwise defaults to 'us-east-1'
	                ds.region = Refinery::Videos.s3_region if Refinery::Videos.s3_region
                }
            end
          end
        end

        # Injects Dragonfly::Middleware for Refinery::Videos into the stack
        def attach!(app)
          if defined?(::Rack::Cache)
            unless app.config.action_controller.perform_caching && app.config.action_dispatch.rack_cache
              app.config.middleware.insert 0, ::Rack::Cache, {
                verbose: true,
                metastore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"), # URI encoded in case of spaces
                entitystore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")
              }
            end
            app.config.middleware.insert_after ::Rack::Cache, ::Dragonfly::Middleware, :refinery_videos
          else
            app.config.middleware.use ::Dragonfly::Middleware, :refinery_videos
          end
        end
      end

    end
  end
end

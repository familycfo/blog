# name: blog
# about: blog frontend for Discourse
# version: 0.1
# authors: Sam Saffron

# gem "multi_xml","0.5.5"
# gem "httparty", "0.12.0"
# TODO consider serel
# gem "serel", "1.2.0"

::BLOG_HOST = Rails.env.development? ? "edubbs.club"
::BLOG_DISCOURSE = Rails.env.development? ? "edubbs.org"




after_initialize do

  # got to patch this class to allow more hostnames
  class ::Middleware::EnforceHostname
    def call(env)
      hostname = env[Rack::Request::HTTP_X_FORWARDED_HOST].presence || env[Rack::HTTP_HOST]

      env[Rack::Request::HTTP_X_FORWARDED_HOST] = nil

      if hostname == ::BLOG_HOST
        env[Rack::HTTP_HOST] = ::BLOG_HOST
      else
        env[Rack::HTTP_HOST] = ::BLOG_DISCOURSE
      end

      @app.call(env)
    end
  end

end

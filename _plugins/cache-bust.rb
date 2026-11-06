# frozen_string_literal: true

# Appends a content hash to asset URLs (e.g. theme.js?3f2a...), so browsers
# download a file again only after it changes.
# Based on al-folio's cache-bust plugin.
require "digest"

module Jekyll
  module CacheBust
    # {{ '/assets/js/theme.js' | relative_url | bust_file_cache }}
    def bust_file_cache(url)
      local_path = url[url.index("assets/")..]
      "#{url}?#{content_digest([local_path])}"
    end

    # main.css is compiled from assets/css/main.scss and the files in _sass/.
    def bust_css_cache(url)
      sources = ["assets/css/main.scss"] + Dir.glob("_sass/**/*.scss", base: site_source).sort
      "#{url}?#{content_digest(sources)}"
    end

    private

    def site_source
      @context.registers[:site].source
    end

    def content_digest(relative_paths)
      content = relative_paths.map { |path| File.read(File.join(site_source, path)) }.join
      Digest::SHA256.hexdigest(content)[0, 32]
    end
  end
end

Liquid::Template.register_filter(Jekyll::CacheBust)

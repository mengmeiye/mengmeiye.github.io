# frozen_string_literal: true

# Adds rel="external nofollow noopener" and target="_blank" to links that point
# outside the site, the same way the jekyll-link-attributes gem did (but
# without needing Nokogiri). A rel or target already set on a link is kept.
# Settings: `external_links` in _config.yml.
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output_ext == ".html"

  config = doc.site.config
  options = config["external_links"] || {}
  next if options["enabled"] == false

  site_url = config["url"].to_s
  rel = options["rel"] || "external nofollow noopener"
  target = options["target"] || "_blank"

  doc.output = doc.output.gsub(/<a\s[^>]*>/i) do |tag|
    href = tag[/\shref\s*=\s*["']([^"']*)["']/i, 1].to_s
    next tag unless href.match?(%r{\Ahttps?://}i)
    next tag if !site_url.empty? && href.start_with?(site_url)

    extra = +""
    extra << %( rel="#{rel}") unless tag.match?(/\srel\s*=/i)
    extra << %( target="#{target}") unless tag.match?(/\starget\s*=/i)
    tag.sub(/\s*>\z/) { "#{extra}>" }
  end
end

# frozen_string_literal: true

# Removes HTML comments (<!-- ... -->) from generated pages, so text that is
# commented out in the Markdown files is not published in the page source.
# (The old setup did this as part of jekyll-minifier.)
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output_ext == ".html"

  html = doc.output
  kept = +""
  pos = 0
  while (start = html.index("<!--", pos)) && (stop = html.index("-->", start + 4))
    kept << html[pos...start]
    pos = stop + 3
  end
  kept << html[pos..]
  doc.output = kept
end

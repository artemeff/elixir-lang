module Jekyll
  module TextPreviewFilter
    def to_preview(input)
      input.split("\n").first
    end
  end
end

Liquid::Template.register_filter(Jekyll::TextPreviewFilter)

module Docs
  class Devsite
    # Notes which top-level section of the site's left-hand menu holds this
    # page (e.g. "Deploy services"), for sites whose breadcrumbs stop at the
    # product. Runs before the page is cut down to the article, which drops the
    # menu; the entries filter reads the note and the cleaner removes it.
    class NavSectionFilter < Filter
      def call
        article = at_css(context[:container]) or return doc
        section = section_of(current_link)
        if section
          marker = doc.document.create_element('div')
          marker['data-devsite-section'] = section
          article.prepend_child(marker)
        end
        doc
      end

      private

      def current_link
        path = URI.parse(current_url.to_s).path.chomp('/')
        css('devsite-book-nav a.devsite-nav-title[href]').find do |link|
          link['href'].sub(/[?#].*\z/, '').sub(%r{\Ahttps?://[^/]+}, '').chomp('/') == path
        end
      rescue URI::InvalidURIError
        nil
      end

      # The outermost expandable group around the link, or else the heading above it in a flat list.
      def section_of(link)
        return unless link
        group = link.ancestors('li.devsite-nav-expandable').last
        title = group&.at_css('> .devsite-expandable-nav > .devsite-nav-title .devsite-nav-text') ||
                group&.at_css('.devsite-nav-title .devsite-nav-text')
        return title.content.squish.presence if title

        item = link.ancestors('li.devsite-nav-item').last
        heading = item&.xpath('preceding-sibling::li[contains(@class, "devsite-nav-heading")][1]')&.first
        heading&.content&.squish.presence
      end
    end
  end
end

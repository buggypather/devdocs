module Docs
  class Devsite
    class EntriesFilter < Docs::EntriesFilter
      def get_name
        title = (at_css('h1.devsite-page-title') || at_css('h1'))&.dup
        return super unless title
        # The heading also holds the bookmark button and its tooltip.
        title.css('devsite-actions, devsite-feature-tooltip, devsite-bookmark, .nocontent, .devsite-page-title-meta').remove
        title.content.squish.presence || super
      end

      # The first breadcrumb after the site's own (options[:devsite_skip_crumbs]),
      # e.g. "Authentication" in "Firebase › Documentation › Authentication".
      # With options[:devsite_crumbs_after], only the breadcrumbs after that one
      # count, e.g. after "Cloud Run" in "Home › Documentation › Application hosting › Cloud Run".
      def get_type
        # Set by devsite/nav_section, for sites whose breadcrumbs don't go deep enough.
        section = at_css('[data-devsite-section]')&.[]('data-devsite-section')
        return section if section.present?

        crumbs = css('.devsite-breadcrumb-list .devsite-breadcrumb-link').map { |node| node.content.squish }
        if (after = context[:devsite_crumbs_after])
          index = crumbs.rindex(after)
          # A trail without the product's name says nothing useful about the page.
          crumbs = index ? crumbs.drop(index + 1) : []
        end
        skip = Array(context[:devsite_skip_crumbs])
        crumbs = crumbs.drop_while { |crumb| skip.include?(crumb) }
        crumbs.first.presence || type_from_path
      end

      def include_default_entry?
        !root_page?
      end

      private

      # For pages without breadcrumbs: the first folder of the page's path, e.g. "Cloud run" for run/docs/...
      def type_from_path
        return context[:devsite_default_type] if context[:devsite_default_type]
        subpath.split('/').first.to_s.tr('-', ' ').capitalize.presence || 'Overview'
      end
    end
  end
end

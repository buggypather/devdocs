module Docs
  # Google's documentation sites (firebase.google.com, source.android.com,
  # cloud.google.com, ...) are all built with the same system, "devsite", so
  # their pages share one layout. The docs scraped from them build on this.
  class Devsite < UrlScraper
    self.abstract = true
    self.type = 'simple'
    # The sites aren't versioned: the release is the month they were scraped.
    self.release = Time.now.utc.strftime('%Y-%m')
    self.headers = { 'User-Agent' => 'DevDocs scraper (+https://github.com/buggypather/devdocs)' }

    html_filters.push 'devsite/entries', 'devsite/clean_html'

    options[:container] = '.devsite-article'
    options[:rate_limit] = 240 # per minute, i.e. 4 pages a second

    # Breadcrumbs at the start of every page's trail, e.g. "Firebase › Documentation".
    # The first one after them names the page's type (its group in the sidebar).
    options[:devsite_skip_crumbs] = []
    # The heading of the docs' home page, which has no title of its own.
    options[:devsite_root_title] = nil

    # Links carry the reader's language and account (?hl=, ?authuser=).
    options[:fix_urls] = ->(url) do
      url.sub(/\?.*\z/, '')
    end

    options[:attribution] = <<-HTML
      &copy; Google LLC<br>
      Text licensed under the Creative Commons Attribution 4.0 License; code samples under the Apache License 2.0.
    HTML
  end
end

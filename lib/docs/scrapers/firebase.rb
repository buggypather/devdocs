module Docs
  # Firebase's guides, from firebase.google.com/docs. The API references are
  # left out: the JavaScript one is published as Markdown and makes a better
  # doc pack (github.com/buggypather/devdocs-pack-firebase).
  class Firebase < Devsite
    self.name = 'Firebase'
    self.base_url = 'https://firebase.google.com/docs/'
    self.root_path = '/'
    self.links = {
      home: 'https://firebase.google.com/docs',
      code: 'https://github.com/firebase'
    }

    # Firebase's own entries filter replaces the shared one.
    html_filters.replace 'devsite/entries', 'firebase/entries'

    options[:devsite_skip_crumbs] = ['Firebase', 'Documentation']
    options[:devsite_root_title] = 'Firebase'
    options[:skip_patterns] = [
      /\Areference\//,
      /\Asamples\//,
      /\Aresources\//,
      /\Aabout\//,
      /\Asupport\//,
      /\Adownloads\//,
      /release-notes/,
      /\.(zip|json|txt|pdf)\z/
    ]
  end
end

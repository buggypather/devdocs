module Docs
  # The Android app developers' guides, from developer.android.com: Jetpack
  # Compose and the rest of the UI toolkit, app architecture, Android Studio,
  # Kotlin, Wear OS, TV, games, Google Play and the platform releases. The API
  # reference (/reference) is left out: it's tens of thousands of pages, more
  # than one doc pack can hold. So are the blog, codelabs, samples, the Jetpack
  # libraries' release notes and the translations (/intl/).
  class Android < Devsite
    self.name = 'Android'
    self.slug = 'android'
    self.base_url = 'https://developer.android.com/'
    self.root_path = 'develop'
    self.initial_paths = %w(
      get-started/overview
      guide
      topic/architecture/intro
      design/ui
      studio
      kotlin
      games
      about/versions
      privacy-and-security
      quality
      distribute
    )
    self.links = {
      home: 'https://developer.android.com/',
      code: 'https://android.googlesource.com/'
    }

    # E.g. "Android Developers › Design & Plan › App architecture": the site, the
    # tab, then the page's area, which becomes its group in the sidebar.
    options[:devsite_skip_crumbs] = ['Android Developers', 'Essentials', 'Design & Plan', 'Develop', 'Google Play']
    options[:devsite_root_title] = 'Android Developers'
    options[:skip_patterns] = [
      /(\A|\/)reference\//,
      /\Areference\z/,
      /\Aintl\//,
      /\A(blog|news|events|stories|shop|community|courses|codelabs|samples|videos|podcasts)(\/|\z)/,
      /\A(license|legal|terms|privacy)(\/|\z)/,
      /\Ajetpack\/androidx\/releases\//,
      /\Astudio\/(releases|preview|archive)\//,
      /\Asdk\/api_diff\//,
      /\Adownload/,
      /\.(zip|json|txt|pdf|tgz|gz|xml|apk|aar|jar|png|jpg|gif|svg|mp4)\z/
    ]

    # Links carry the reader's language and account (?hl=, ?authuser=), and old
    # ones end in .html or /index.html; keep one address per page, and its #anchor.
    options[:fix_urls] = ->(url) do
      url = url.sub(/\?[^#]*/, '')
      return url unless url.start_with?('https://developer.android.com/')
      url.sub(/(\/index)?\.html(?=#|\z)/, '')
    end

    # As developer.android.com/license asks: the documentation and its code are
    # under Apache 2.0, the site's other content under CC BY 2.5, with this credit.
    options[:attribution] = <<-HTML
      &copy; Google LLC and the Android Open Source Project<br>
      Documentation and code samples licensed under the Apache License 2.0. Portions of this page are modifications based on work created and shared by the Android Open Source Project and used according to terms described in the Creative Commons 2.5 Attribution License.
    HTML
  end
end

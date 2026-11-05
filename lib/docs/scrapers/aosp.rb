module Docs
  # The Android Open Source Project's documentation, from source.android.com/docs:
  # how the Android OS is built, ported, tested and secured. The generated API
  # references (Trade Federation, HALs) and the monthly security bulletins are
  # left out: together they're two thirds of the site.
  class Aosp < Devsite
    self.name = 'Android OS (AOSP)'
    self.slug = 'aosp'
    self.base_url = 'https://source.android.com/docs/'
    self.root_path = '/'
    self.links = {
      home: 'https://source.android.com/docs',
      code: 'https://android.googlesource.com/'
    }

    options[:devsite_skip_crumbs] = ['AOSP', 'Docs', 'Core topics']
    options[:devsite_root_title] = 'Android Open Source Project'
    options[:skip_patterns] = [
      /\/reference\//,
      /\Areference\//,
      /\Asecurity\/bulletin\//,
      /\.(zip|json|txt|pdf|tgz|gz|xml)\z/
    ]
  end
end

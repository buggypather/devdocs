module Docs
  # Google Cloud's guides, one product per version (google_cloud~cloud_run, ...),
  # from docs.cloud.google.com/<product>/docs (mostly). The whole site has some 60,000 guide
  # pages, far too many for one doc, so only the products listed here are
  # scraped; add a line to PRODUCTS for another. The API and client library
  # references, code sample pages and release notes are left out.
  class GoogleCloud < Devsite
    self.name = 'Google Cloud'
    self.slug = 'google_cloud'
    self.links = {
      home: 'https://docs.cloud.google.com/docs',
      code: 'https://github.com/GoogleCloudPlatform'
    }

    # The product's name as its breadcrumbs write it, and its docs folder on docs.cloud.google.com.
    # Products move now and then (Firestore to native/docs; Vertex AI became Gemini Enterprise
    # Agent Platform, with no docs/ folder), so check a product's address if its scrape fails.
    PRODUCTS = {
      'Cloud Run' => 'run/docs',
      'Cloud Storage' => 'storage/docs',
      'Compute Engine' => 'compute/docs',
      'Google Kubernetes Engine (GKE)' => 'kubernetes-engine/docs',
      'BigQuery' => 'bigquery/docs',
      'Pub/Sub' => 'pubsub/docs',
      'Cloud SQL' => 'sql/docs',
      'Firestore' => 'firestore/native/docs',
      'Identity and Access Management (IAM)' => 'iam/docs',
      'Gemini Enterprise Agent Platform' => 'gemini-enterprise-agent-platform',
      'Google Cloud SDK' => 'sdk/docs'
    }

    # The breadcrumbs stop at "Guides", so pages are grouped by the left-hand menu instead.
    html_filters.insert_before 'container', 'devsite/nav_section'

    options[:skip_patterns] = [
      /(\A|\/)reference\//,
      /(\A|\/)rest\//,
      /(\A|\/)rpc\//,
      /(\A|\/)samples\//,
      /release-notes/,
      /(\A|\/)blog\//,
      /\.(zip|json|txt|pdf|tgz|gz|xml|yaml)\z/
    ]
    # Pages straight under "Guides" in the trail.
    options[:devsite_skip_crumbs] = ['Guides', 'Documentation']
    options[:devsite_default_type] = 'Overview'

    PRODUCTS.each do |product, folder|
      version product do
        self.base_url = "https://docs.cloud.google.com/#{folder}/"
        self.root_path = '/'
        options[:devsite_crumbs_after] = product
        options[:devsite_root_title] = product
      end
    end
  end
end

module Docs
  # Google Cloud's guides, one product per version (google_cloud~cloud_run, ...),
  # from docs.cloud.google.com/<product>/docs. The whole site has some 60,000 guide
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

    # The product's name as its breadcrumbs write it, and its folder on docs.cloud.google.com.
    PRODUCTS = {
      'Cloud Run' => 'run',
      'Cloud Storage' => 'storage',
      'Compute Engine' => 'compute',
      'Google Kubernetes Engine (GKE)' => 'kubernetes-engine',
      'BigQuery' => 'bigquery',
      'Pub/Sub' => 'pubsub',
      'Cloud SQL' => 'sql',
      'Firestore' => 'firestore',
      'Identity and Access Management (IAM)' => 'iam',
      'Vertex AI' => 'vertex-ai',
      'Google Cloud SDK' => 'sdk'
    }

    # The breadcrumbs stop at "Guides", so pages are grouped by the left-hand menu instead.
    html_filters.insert_before 'container', 'devsite/nav_section'

    options[:skip_patterns] = [
      /(\A|\/)reference\//,
      /(\A|\/)rest\//,
      /(\A|\/)rpc\//,
      /(\A|\/)samples\//,
      /release-notes/,
      /\.(zip|json|txt|pdf|tgz|gz|xml|yaml)\z/
    ]
    # Pages straight under "Guides" in the trail.
    options[:devsite_skip_crumbs] = ['Guides', 'Documentation']
    options[:devsite_default_type] = 'Overview'

    PRODUCTS.each do |product, folder|
      version product do
        self.base_url = "https://docs.cloud.google.com/#{folder}/docs/"
        self.root_path = '/'
        options[:devsite_crumbs_after] = product
        options[:devsite_root_title] = product
      end
    end
  end
end

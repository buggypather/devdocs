module Docs
  class Firebase
    class EntriesFilter < Docs::Devsite::EntriesFilter
      # The products' names as the site writes them, for pages whose
      # breadcrumbs don't say.
      PRODUCTS = {
        'ai-logic' => 'AI Logic',
        'app-check' => 'App Check',
        'auth' => 'Authentication',
        'cloud-messaging' => 'Cloud Messaging',
        'database' => 'Realtime Database',
        'firestore' => 'Cloud Firestore',
        'functions' => 'Cloud Functions',
        'perf-mon' => 'Performance Monitoring',
        'sql-connect' => 'SQL Connect',
        'storage' => 'Cloud Storage'
      }

      private

      def type_from_path
        PRODUCTS[subpath.split('/').first.to_s] || super
      end
    end
  end
end

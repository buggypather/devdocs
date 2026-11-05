require_relative '../../../../test_helper'
require_relative '../../../../../lib/docs'

# A page of firebase.google.com/docs, cut down to what the filters look at.
FIREBASE_PAGE = <<~HTML
  <div class="devsite-article-meta nocontent">
    <ul class="devsite-breadcrumb-list">
      <li><a class="devsite-breadcrumb-link" href="/">Firebase</a></li>
      <li><a class="devsite-breadcrumb-link" href="/docs">Documentation</a></li>
      <li><a class="devsite-breadcrumb-link" href="/docs/auth">Authentication</a></li>
    </ul>
  </div>
  <h1 class="devsite-page-title">Get started<devsite-actions><devsite-feature-tooltip class="nocontent">Stay organized</devsite-feature-tooltip></devsite-actions></h1>
  <devsite-toc class="devsite-nav"><a href="#a">On this page</a></devsite-toc>
  <div class="devsite-article-body">
    <section class="firebase-ai-prompt-cards"><pre>Help me use Firebase</pre></section>
    <h2 id="add" data-text="Add" tabindex="-1">Add the <span class="notranslate">Authentication</span> SDK</h2>
    <devsite-selector>
      <section><h3 id="web"><span class="two-line-tab"><span tab-label="modular API">Web</span></span></h3>
        <div class="devsite-github-link nocontent">View on GitHub</div>
        <devsite-code><pre class="devsite-click-to-copy" syntax="Python"><span class="devsite-syntax-kn">import</span> x</pre></devsite-code>
      </section>
    </devsite-selector>
    <div class="ds-selector-tabs">
      <section><h5 id="swift"><devsite-analytics-scope>Swift</devsite-analytics-scope></h5><pre>let x = 1</pre></section>
    </div>
    <devsite-thumb-rating>Was this helpful?</devsite-thumb-rating>
  </div>
HTML

class FirebaseCleanHtmlFilterTest < Minitest::Spec
  include FilterTestHelper
  self.filter_class = Docs::Devsite::CleanHtmlFilter
  self.filter_type = 'html'

  before do
    context[:base_url] = 'https://firebase.google.com/docs/'
    context[:root_url] = 'https://firebase.google.com/docs/'
    context[:url] = 'https://firebase.google.com/docs/auth/web/start'
    context[:devsite_root_title] = 'Firebase'
    context[:devsite_skip_crumbs] = ['Firebase', 'Documentation']
    @body = FIREBASE_PAGE
  end

  it "keeps the title and the article, without Google's page furniture" do
    html = filter_output_string
    assert html.start_with?('<h1>Get started</h1>')
    %w(Stay\ organized On\ this\ page View\ on\ GitHub Was\ this\ helpful Help\ me\ use devsite-).each do |text|
      refute_includes html, text
    end
    assert_includes html, '<h2 id="add">Add the Authentication SDK</h2>'
  end

  it "labels each tab of a code sample, and colours its code in the tab's language" do
    html = filter_output_string
    assert_includes html, '<p class="_code-tab"><strong>Web (modular API)</strong></p>'
    assert_includes html, '<pre data-language="javascript">import x</pre>'
    assert_match %r{<p class="_code-tab"><strong>Swift</strong></p>\s*<pre data-language="swift">let x = 1</pre>}, html
  end

  it "titles a landing page without one" do
    context[:url] = 'https://firebase.google.com/docs/'
    @body = '<div class="devsite-article-body"><p>Hi</p></div>'
    assert_equal '<h1>Firebase</h1><p>Hi</p>', filter_output_string
  end
end

class FirebaseEntriesFilterTest < Minitest::Spec
  include FilterTestHelper
  self.filter_class = Docs::Firebase::EntriesFilter
  self.filter_type = 'html'

  before do
    context[:base_url] = 'https://firebase.google.com/docs/'
    context[:root_url] = 'https://firebase.google.com/docs/'
    context[:url] = 'https://firebase.google.com/docs/auth/web/start'
    context[:devsite_root_title] = 'Firebase'
    context[:devsite_skip_crumbs] = ['Firebase', 'Documentation']
    @body = FIREBASE_PAGE
  end

  it "names the page by its title, and groups it by product" do
    assert_equal 'Get started', filter.name
    assert_equal 'Authentication', filter.type
  end

  it "groups pages without breadcrumbs by the product in their address" do
    context[:url] = 'https://firebase.google.com/docs/firestore/query-data/get-data'
    @body = '<h1 class="devsite-page-title">Get data</h1>'
    assert_equal 'Cloud Firestore', filter.type
  end
end

class AospEntriesFilterTest < Minitest::Spec
  include FilterTestHelper
  self.filter_class = Docs::Devsite::EntriesFilter
  self.filter_type = 'html'

  before do
    context[:base_url] = 'https://source.android.com/docs/'
    context[:root_url] = 'https://source.android.com/docs/'
    context[:url] = 'https://source.android.com/docs/core/architecture/hidl'
    context[:devsite_skip_crumbs] = ['AOSP', 'Docs', 'Core topics']
    @body = <<~HTML
      <ul class="devsite-breadcrumb-list">
        <li><a class="devsite-breadcrumb-link">AOSP</a></li>
        <li><a class="devsite-breadcrumb-link">Docs</a></li>
        <li><a class="devsite-breadcrumb-link">Core topics</a></li>
        <li><a class="devsite-breadcrumb-link">Architecture and Platform</a></li>
      </ul>
      <h1 class="devsite-page-title">HIDL <span class="devsite-page-title-meta">Stay organized with collections</span></h1>
    HTML
  end

  it "skips the site's own breadcrumbs and the title's extras" do
    assert_equal 'HIDL', filter.name
    assert_equal 'Architecture and Platform', filter.type
  end

  it "falls back to the first folder of the address" do
    @body = '<h1 class="devsite-page-title">Audio</h1>'
    context[:url] = 'https://source.android.com/docs/core-audio/overview'
    assert_equal 'Core audio', filter.type
  end
end

class DevsiteNavSectionFilterTest < Minitest::Spec
  include FilterTestHelper
  self.filter_class = Docs::Devsite::NavSectionFilter
  self.filter_type = 'html'

  before do
    context[:base_url] = 'https://docs.cloud.google.com/run/docs/'
    context[:root_url] = 'https://docs.cloud.google.com/run/docs/'
    context[:url] = 'https://docs.cloud.google.com/run/docs/deploying'
    context[:container] = '.devsite-article'
    @body = <<~HTML
      <devsite-book-nav><ul class="devsite-nav-list">
        <li class="devsite-nav-item"><a href="/run/docs/overview" class="devsite-nav-title"><span class="devsite-nav-text">Overview</span></a></li>
        <li class="devsite-nav-item devsite-nav-expandable"><div class="devsite-expandable-nav">
          <div class="devsite-nav-title"><span class="devsite-nav-text">Deploy services</span></div>
          <ul class="devsite-nav-section">
            <li class="devsite-nav-item devsite-nav-expandable"><div class="devsite-expandable-nav">
              <div class="devsite-nav-title"><span class="devsite-nav-text">Deploy container images</span></div>
              <ul class="devsite-nav-section">
                <li class="devsite-nav-item"><a href="/run/docs/deploying?hl=en" class="devsite-nav-title"><span class="devsite-nav-text">Deploy containers</span></a></li>
              </ul>
            </div></li>
          </ul>
        </div></li>
      </ul></devsite-book-nav>
      <article class="devsite-article"><h1>Deploy</h1></article>
    HTML
  end

  it "notes the page's top-level menu section in the article" do
    assert_includes filter_output_string, '<article class="devsite-article"><div data-devsite-section="Deploy services"></div>'
  end

  it "adds nothing for a page that isn't in the menu" do
    context[:url] = 'https://docs.cloud.google.com/run/docs/elsewhere'
    refute_includes filter_output_string, 'data-devsite-section'
  end
end

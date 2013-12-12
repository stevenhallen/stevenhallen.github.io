###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  blog.prefix = "articles"
  blog.permalink = ":year/:title.html"
  blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  blog.layout = "blog_layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/:num"
end

page "/feed.xml", layout: false

set :css_dir, 'stylesheets'
set :images_dir, 'images'
set :js_dir, 'javascripts'
set :haml, { format: :html5, ugly: true }

foundation_path = Gem::Specification.find_by_name('zurb-foundation').gem_dir
sprockets.append_path "#{File.join(foundation_path, 'js')}"
set :sass_assets_paths, [File.join(foundation_path, 'scss')]

set :markdown_engine, :kramdown

page '/sitemap.xml', layout: false

pages = [
  '/what_we_do.html',
  '/our_work.html',
  '/blog.html',
  '/about.html',
  '/jobs.html',
  '/contact.html'
]

pages.each do |the_page|
  page the_page, layout: :page_layout
end

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

helpers do

  # Helper to allow partials to contain frontmatter
  # Thanks to Vernon Kesner @ vernonkesner.com
  # http://vernonkesner.com/blog/2013/02/16/using-frontmatter-in-partials-within-middleman/
  #
  # Note that this changes how to access data
  # Instead of: current_page.data.foobar, it is: foobar
  def snippet(component, overrides = nil)

    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def red(text); colorize(text, 31); end
    def green(text); colorize(text, 32); end


    basepath = File.expand_path File.dirname(__FILE__)
    exists = File.exists?(basepath << "/source/" << component << ".haml")

    if exists
      # Read the partial, get the YAML, extend that hash with any overrides passed in
      yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
      content = File.read(basepath)
      content = content.sub(yaml_regex, "")
      data = YAML.load($1)

      # Extend the hash so that any overrides are used instead of the defaults
      if overrides != nil
        overrides.each_key do |key|
          data[key] = overrides[key]
        end
      end
    else
      puts red('[ERROR:]') + " Partial #{component} not found!"
      return '<span style="color: red; font-weight: bold;">Error: Partial \'' + component + '\' not found!</span>'
    end

    ##
    # At this point, we have our data and know it exists
    # Just load that partial baby
    ##
    partial component, :locals => data

  end
end

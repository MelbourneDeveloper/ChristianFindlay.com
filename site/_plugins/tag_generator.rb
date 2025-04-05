module Jekyll
  class CustomTagPageGenerator < Generator
    safe true
    priority :low  # Make sure our generator runs after other tag generators

    def generate(site)
      if site.layouts.key? 'tag_page'
        # Get unique tags (case insensitive)
        tags_hash = {}
        site.posts.docs.each do |post|
          (post.data['tags'] || []).each do |tag|
            tag_key = tag.downcase
            # Store the original tag casing as the value if not already present
            tags_hash[tag_key] ||= tag
          end
        end
        
        # Create pages for each unique tag
        tags_hash.each do |tag_key, tag|
          # Create a tag page at /tag/TAG/ to avoid conflicts
          site.pages << CustomTagPage.new(site, site.source, tag)
        end
      end
    end
  end

  class CustomTagPage < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @dir = File.join('tag', tag.downcase.gsub(' ', '-'))
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_page.html')
      self.data['tag'] = tag
      self.data['title'] = "#{tag.capitalize} Articles"
    end
  end
end 
require 'nokogiri'

class HudsonStatusParser
  attr_accessor :success, :building, :url, :published_at

  def self.building(content, project)
    building_parser = self.new
    document = Nokogiri::XML.parse(content.downcase)
    document.css("entry title").each do |title|
      if title.content.downcase =~ /#{project.project_name.downcase}/
        building_parser.building = title.content.downcase.include?('null')
      end
    end
    building_parser
  end

  def self.status(content)
    status_parser = self.new
    latest_build = Nokogiri::XML.parse(content.downcase).css('feed entry:first').first
    status_parser.success = !!(find(latest_build, 'title').first.content =~ /success/)
    status_parser.url = find(latest_build, 'link').first.attribute('href').value
    pub_date = Time.parse(find(latest_build, 'published').first.content)
    status_parser.published_at = (pub_date == Time.at(0) ? Clock.now : pub_date).localtime
    status_parser
  end

  def self.find(document, path)
    document.css("#{path}")
  end

  def building?
    @building
  end

  def success?
    @success
  end
end


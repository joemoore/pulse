class CruiseControlProject < Project
  validates_format_of :feed_url, :with => /http:\/\/.*.rss$/
  
  def project_name
    return nil if feed_url.nil?
    URI.parse(feed_url).path.scan(/^.*\/(.*)\.rss/i)[0][0]
  end

  def building_parser(content)
    CruseControlStatusParser.building(content, self)
  end

  def status_parser(content)
    CruseControlStatusParser.status(content)
  end
end
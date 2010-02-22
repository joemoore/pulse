class CruiseControlProject < Project
  def project_name
    return nil if feed_url.nil?
    URI.parse(feed_url).path.scan(/^.*\/(.*)\.rss/i)[0][0]
  end
end
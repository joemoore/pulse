class HudsonProject < Project
  validates_format_of :feed_url, :with =>  /http:\/\/.*job\/.*\/rssAll$/

  def project_name
    return nil if feed_url.nil?
    URI.parse(feed_url).path.scan(/^.*job\/(.*)/i)[0][0].split('/').first
  end
end
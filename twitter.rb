require 'net/http'

#TwitterWordFrequency.new("2", "BarakObama")

class TwitterWordFrequency

  attr_accessor :count, :screen_name
  
  def initialize count, screen_name
    @count = count
    @screen_name = screen_name
  end
  
  def getTweets
    uri = URI "https://api.twitter.com/1/statuses/user_timeline.json"
    params = {:count => @count, :screen_name => @screen_name, :trim_user => true}
    uri.query = URI.encode_www_form(params)
    
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri

      response = http.request request # Net::HTTPResponse object
      puts response.body if response.is_a? Net::HTTPSuccess
    end
    
  end
  
end


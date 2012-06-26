require 'net/http'
require 'json'

#TwitterWordFrequency.new("2", "BarackObama")

class TwitterWordFrequency

  attr_accessor :count, :screen_name
  
  def initialize count, screen_name
    @count = count
    @screen_name = screen_name
  end
  
  def getTweets max_id
    uri = URI "https://api.twitter.com/1/statuses/user_timeline.json"
    if max_id
      params = {:screen_name => @screen_name, :count => "200", :trim_user => "true", :max_id => max_id}
    else
      params = {:screen_name => @screen_name, :count => "200", :trim_user => "true"}
    end
    uri.query = URI.encode_www_form(params)
    
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri

      response = http.request request # Net::HTTPResponse object
      return response.body
    end
  end
  
  def getWordCount
    @words = {}
    max_id = nil
    count = 0
    
    while count < @count.to_i do
      tweets = JSON.parse(getTweets max_id)
      tweets.each do |tweet|
        updateWordCount tweet["text"]
        max_id = tweet["id"]
      end
      count += 200
    end
    return @words.sort_by { |word, count| count}
  end
  
  private
  
  def updateWordCount(string)
    string.downcase.split(" ").each do |word|
      entry = word.gsub(/\W/, "")
      if(@words.has_key? entry)
        @words[entry] += 1
      elsif(entry != "") 
        @words[entry] = 1
      end
    end
  end  
  
end

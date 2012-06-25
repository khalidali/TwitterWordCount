require 'net/http'
require 'json'

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
      return response.body
    end
  end
  
  def parseTweets
    words = {}
    tweets = JSON.parse(getTweets)
    tweets.each do |tweet|
      tweet["text"].downcase.split(" ").each do |word|
        word = word.gsub(/\W/, "")
        if(words.has_key? word)
          words[word] += 1
        elsif(word != "") 
          words[word] = 1
        end 
      end
    end
    return words
  end
  
  def words
    
  
  
  
  end
  
  
  
  
end


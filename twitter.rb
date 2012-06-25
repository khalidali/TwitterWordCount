require 'net/http'
require 'json'

#TwitterWordFrequency.new("2", "BarakObama")

COUNT = 10

class TwitterWordFrequency

  attr_accessor :count, :screen_name, :words
  
  def initialize count, screen_name
    @count = count
    @screen_name = screen_name
  end
  
  def getTweets max_id
    uri = URI "https://api.twitter.com/1/statuses/user_timeline.json"
    if max_id
      params = {:count => COUNT, :screen_name => @screen_name, :trim_user => true, :max_id => max_id}
    else
      params = {:count => COUNT, :screen_name => @screen_name, :trim_user => true}
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
    count = 0
    max_id = nil
    
    
    while count < @count
      
      tweets = JSON.parse(getTweets max_id)
      
      tweets.each do |tweet|
        tweet["text"].downcase.split(" ").each do |word|
          word = word.gsub(/\W/, "")
          if(words.has_key? word)
            words[word] += 1
          elsif(word != "") 
            words[word] = 1
          end 
        max_id = tweet["id"]
        end
      end
      count += COUNT
    end
    return words.sort_by { |word, count| count}
  end
end


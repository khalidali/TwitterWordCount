require 'net/http'
require 'json'

# Example on how to use:
# obama = TwitterWordCount.new("BarackObama", 1000)
# obama.getWordCount


class TwitterWordCount

  attr_accessor :screen_name, :count
  
  def initialize screen_name, count
    @count = count
    @screen_name = screen_name
  end
  
  def getTweets max_id, count
    uri = URI "https://api.twitter.com/1/statuses/user_timeline.json"
    params = {:screen_name => @screen_name, :count => count, :trim_user => "true"}
    params[:max_id] = max_id unless max_id == nil
    uri.query = URI.encode_www_form params
    
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request 
      return response.body
    end
  end
  
  def getWordCount
    @words = {}
    max_id = nil
    count = @count
    
    while count > 0 do
      size = count<200? count : 200 
      tweets = JSON.parse getTweets(max_id, size)
      tweets.each do |tweet|
        updateWordCount tweet["text"]
        max_id = tweet["id"]
      end
      count -= size
    end
    return @words.sort_by { |word, count| count}.reverse
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

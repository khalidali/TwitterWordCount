require 'net/http'


class TwitterWordFrequency

  attr_accessor :count, :user_id
  
  def initialize count, user_id
    @count = count
    @user_id = user_id
  end
  
  def getTweets
    uri = URI "https://api.twitter.com/1/statuses/user_timeline.json"
    params = {:count => @count, :user_id => @user_id}
    uri.query = URI.encode_www_form(params)
    
    response = Net::HTTP.get_response(uri)
    puts res.body if res.is_a? Net::HTTPSuccess
  end
  
end


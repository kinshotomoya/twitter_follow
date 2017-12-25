class TwitterService
  require 'twitter'

  class << self
    def get_tweet
      @client = get_client
      # 自分がfollowしている人（片思い）
      @one_side_loves_user_array = get_one_side_loves_ids
      # 自分をfollowしている人(チョコガール(自分のこと好き))
      @follower_array = get_follower_ids
      @unfollower_array =  select_unfollower_ids
      unfollow_users
    end

    private

    def get_client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["CONSUMER_KEY"]
        config.consumer_secret     = ENV["CONSUMER_SECRET"]
        config.access_token        = ENV["ACCESS_TOKEN"]
        config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
      end
      client
    end

    def get_one_side_loves_ids
      @client.friends.map { |friend| friend.id }
    end

    def get_follower_ids
      @client.followers.map { |follower| follower.id }
    end

    def select_unfollower_ids
      @one_side_loves_user_array.map do |friend|
        unfollow_array.push(friend) if @follower_array.exclude?(friend)
      end
    end

    def unfollow_users
      @unfollower_array.each do |unfollow_user|
        @client.unfollow(unfollow_user)
      end
    end
  end
end

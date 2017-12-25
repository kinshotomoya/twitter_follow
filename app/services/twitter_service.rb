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
        config.consumer_key        = "ghzvww4mSI0icQaPFgydd8CnV"
        config.consumer_secret     = "ItvBMRot8RQgTRWaSoi2QIpeBWWwiVXLI5fmy7LI4MCw4IG9U9"
        config.access_token        = "945298659477827585-HqB3DTOA4gyQ0ASjRPr8cBGOsoUiRxy"
        config.access_token_secret = "tbMiqw4U2ZX5sowao2O16JKtenrPGot93woawAw3lwtxO"
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
      unfollow_array = []
      @one_side_loves_user_array.each do |friend|
        unfollow_array.push(friend) if @follower_array.exclude?(friend)
      end
      unfollow_array
    end

    def unfollow_users
      @unfollower_array.each do |unfollow_user|
        @client.unfollow(unfollow_user)
      end
    end
  end
end

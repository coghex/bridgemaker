require 'redd'

class String
  alias :each :each_char
end

session = Redd.it(
  user_agent: 'coghex',
  client_id:  'DNrz4_aINUXG-Q',
  secret:     '9lVhK-1Xd9a3T8Rwl3CM4eN8ihM',
  username:   'coghex',
  password:   'immpmd'
)

Signal.trap("INT") {
  exit
}

session.subreddit('all').comment_stream do |comment|
  ARGV.each do|a|
    if comment.body.include? a
      print comment.body
    end
  end
end

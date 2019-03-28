# Dessert

A lightweight recommendation engine for Ruby apps using Redis. Inspired by [DEVIEW presentation](https://www.slideshare.net/deview/261-52784785) and [recommendable](https://github.com/davidcelis/recommendable) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dessert'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dessert
    
## Important Note

* It is highly recommended to use background jobs like [Resque](https://github.com/defunkt/resque) or [Sidekiq](https://github.com/mperham/sidekiq) when calling `like` / `unlike` methods, because there is a bit of computation work.

* Every _rater_ and _ratable items_ should have an `id` method.

* Hidden items will not be recommended.

## Usage

1. Include `Dessert::Rater` on your `User` model.
```ruby
class User
  include Dessert::Rater

  attr_accessor :id

  def initialize(id)
    @id = id
  end

  ...
end
```

2. Define any class that can be rated.
```ruby
class Movie
  attr_accessor :id

  def initialize(id)
    @id = id
  end
end
```

3. Like, Unlike, Hide, Unhide items.
```ruby
user = User.new(1)
movie = Movie.new(483)

user.like(movie)
user.unlike(movie)

user.hide(movie)
user.unhide(movie)
```

4. Now recommend to users!
```ruby
  user = User.new(1)
  user.recommended_for(klass: Movie, offset: 0, limit: 10)
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/mu29/dessert/issues).

## Author

InJung Chung / [@mu29](https://yeoubi.net)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

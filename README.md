# Octopoller 🦑
<a href="https://classroom.github.com"><img src="https://raw.githubusercontent.com/education/classroom/7c8577c29cf354965559503c009bcf4d29b85c2f/app/assets/images/wordmark%402x.png" height="15px"></a> battle tested.

Octopoller is a micro gem for polling and retrying, perfect for making repeating requests.

```ruby
Octopoller.poll(timeout: 15.seconds) do
  begin
    client.request_progress # ex. request a long running job's status
  rescue Error
    :re_poll
  end
end

# => { "status" => 200,  "body" => "🦑" }
```

## About
Octopoller was originally created for the purpose of polling GitHub's [Source Imports API](https://developer.github.com/v3/migrations/source_imports/) for a repo's import status. It is now the backbone of [GitHub Classroom's](https://classroom.github.com) _import starter code_ process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'octopoller'
```

And then execute:
```bash
$ bundle
```
Or install it yourself as:
```bash
$ gem install octopoller
```
## Usage

Octopoller exposes a single function `poll`. Here is what the API looks like:
```ruby
# Polls until success
# Re-runs when the block returns `:re_poll`
#
# wait      - The time delay in seconds between polls (default is 1 second)
#           - When given the argument `:exponentially` the action will be retried with exponetial backoff
# timeout   - The maximum number of seconds the poller will execute
# retries   - The maximum number of times the action will be retried
# yield     - A block that will execute, and if `:re_poll` is returned it will re-run
#           - Re-runs until something is returned or the timeout/retries is reached
# raise     - Raises an Octopoller::TimeoutError if the timeout is reached
# raise     - Raises an Octopoller::TooManyAttemptsError if the retries is reached
#
def poll(wait: 1.second, timeout: nil, retries: nil)
  ...
```

Octopoller has 3 use cases:
* Poll something with a set timeout
* Poll something with a set number of retries
* Poll something with exponential backoff

Here's what using Octpoller is like for each of the use cases listed above:
* Poll with a timeout:
  ```ruby
  Octopoller.poll(timeout: 15.seconds) do
    puts "🦑"
    :re_poll
  end

  # => "🦑"
  # => "🦑"
  # ... (for 15 seconds)
  # Timed out patiently (Octopoller::TimeOutError)
  ```

* Poll with retries:
  ```ruby
  Octopoller.poll(retries: 2) do
    puts "🦑"
    :re_poll
  end

  # => "🦑"
  # => "🦑"
  # => "🦑"
  # Tried maximum number of attempts (Octopoller::TooManyAttemptsError)
  ```

* Poll with exponential backoff:
  ```ruby
  start = Time.now
  Octopoller.poll(wait: :exponentially, retries: 4) do
    puts Time.now - start
    :re_poll
  end

  # => 0.5 seconds
  # => 1 second
  # => 2 seconds
  # => 4 seconds
  # => 8 seconds
  # Tried maximum number of attempts (Octopoller::TooManyAttemptsError)
  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/octokit/octopoller.rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Octopoller project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/octokit/octopoller.rb/blob/main/CODE_OF_CONDUCT.md).

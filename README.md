# OSRMTextInstructions
**WIP: This project is under heavy development and should not be integrated yet.**  

OSRMTextInstructions is a gem to transform OSRM steps into text instructions.

This is an almost verbatim port of [osrm-text-instructions.js](https://github.com/Project-OSRM/osrm-text-instructions).

Only version 5 of the API and the english locale is supported for now.  
This is not stable yet and we still don't have any tests. Use at your own risk.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'osrm_text_instructions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install osrm_text_instructions

## Usage

```ruby
# make your request against the API

legs.each do |leg|
  leg.steps.each do |step|
    instruction = OSRMTextInstructions.compile(step)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zavan/osrm_text_instructions. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
